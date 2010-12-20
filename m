Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab0LTALV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 19:11:21 -0500
Received: from ms01.sssup.it ([193.205.80.99]:45686 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932554Ab0LTALU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:11:20 -0500
Message-ID: <4D0E9F20.6080606@sssup.it>
Date: Mon, 20 Dec 2010 01:11:12 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Harald Gustafsson <hgu1972@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>	<1292596194.2266.283.camel@twins>	<1292612166.2697.68.camel@Palantir>	<1292612385.2708.108.camel@laptop> <AANLkTikO56++q906A1XRbomeASY77wxeEuBqAdx=EttW@mail.gmail.com>
In-Reply-To: <AANLkTikO56++q906A1XRbomeASY77wxeEuBqAdx=EttW@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050508080508070906060206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050508080508070906060206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Il 17/12/2010 20:31, Harald Gustafsson ha scritto:
>>> We already did the very same thing (for another EU Project called
>>> FRESCOR), although it was done in an userspace sort of daemon. It was
>>> also able to consider other "high level" parameters like some estimation
>>> of the QoS of each application and of the global QoS of the system.
>>>
>>> However, converting the basic mechanism into a CPUfreq governor should
>>> be easily doable... The only problem is finding the time for that! ;-P
>> Ah, I think Harald will solve that for you,.. :)
> Yes, I don't mind doing that. Could you point me to the right part of
> the FRESCOR code, Dario?

Hi there,

I'm sorry to join so late this discussion, but the unprecedented 20cm of 
snow in Pisa had some non-negligible drawbacks on my return flight from 
Perth :-).

Let me try to briefly recap what the outcomes of FRESCOR were, w.r.t. 
power management (but usually I'm not that brief :-) ):

1. from a requirements analysis phase, it comes out that it should be 
possible to specify the individual runtimes for each possible frequency, 
as it is well-known that the way computation times scale to CPU 
frequency is application-dependent (and platform-dependent); this 
assumes that as a developer I can specify the possible configurations of 
my real-time app, then the OS will be free to pick the CPU frequency 
that best suites its power management logic (i.e., keeping the minimum 
frequency by which I can meet all the deadlines).

   Requirements Analysis:
   
http://www.frescor.org/index.php?mact=Uploads,cntnt01,getfile,0&cntnt01showtemplate=false&cntnt01upload_id=62&cntnt01returnid=54

   Proposed API:
   
http://www.frescor.org/index.php?mact=Uploads,cntnt01,getfile,0&cntnt01showtemplate=false&cntnt01upload_id=105&cntnt01returnid=54

   I also attach the API we implemented, however consider it is a mix of 
calls for doing both what I wrote above, and building an OS-independent 
abstraction layer for dealing with CPU frequency scaling (and not only) 
on the heterogeneous OSes we had in FRESCOR;

2. this was also assuming, at an API level, a quite static settings 
(typical of hard RT), in which I configure the system and don't change 
its frequency too often; for example, implications of power switches on 
hard real-time requirements (i.e., time windows in which the CPU is not 
operating during the switch, and limits on the max sustainable switching 
frequencies by apps and the like) have not been stated through the API;

3. for soft real-time contexts and Linux (consider FRESCOR targeted both 
hard RT on RT OSes and soft RT on Linux), we played with a much simpler 
trivial linear scaling, which is exactly what has been proposed and 
implemented by someone in this thread on top of SCHED_DEADLINE (AFAIU); 
however, there's a trick which cannot be neglected, i.e., *change 
protocol* (see 5); benchmarks on MPEG-2 decoding times showed that the 
linear approximation is not that bad, but the best interpolating ratio 
between the computing times in different CPU frequencies do not 
perfectly conform to the frequencies ratios; we didn't make any attempt 
of extensive evaluation over different workloads so far. See Figure 4.1 
in D-AQ2v2:

   
http://www.frescor.org/index.php?mact=Uploads,cntnt01,getfile,0&cntnt01showtemplate=false&cntnt01upload_id=82&cntnt01returnid=54

4. I would say that, given the tendency to over-provision the runtime 
(WCET) for hard real-time contexts, it would not bee too much of a 
burden for a hard RT developer to properly over-provision the required 
budget in presence of a trivial runtime rescaling policy like in 2.; 
however, in order to make everybody happy, it doesn't seem a bad idea to 
have something like:
   4a) use the fine runtimes specified by the user if they are available;
   4b) use the trivially rescaled runtimes if the user only specified a 
single runtime, of course it should be clear through the API what is the 
frequency the user is referring its runtime to, in such case (e.g., 
maximum one ?)

5. Mode Change Protocol: whenever a frequency switch occurs (e.g., 
dictated by the non-RT workload fluctuations), runtimes cannot simply be 
rescaled instantaneously: keeping it short, the simplest thing we can do 
is relying on the various CBS servers implemented in the scheduler to 
apply the change from the next "runtime recharge", i.e., the next 
period. This creates the potential problem that the RT tasks have a 
non-negligible transitory for the instances crossing the CPU frequency 
switch, in which they do not have enough runtime for their work. Now, 
the general "rule of thumb" is straightforward: make room first, then 
"pack", i.e., we need to consider 2 distinct cases:

   5a) we want to *increase the CPU frequency*; we can immediately 
increase the frequency, then the RT applications will have a temporary 
over-provisioning of runtime (still tuned for the slower frequency 
case), however as soon as we're sure the CPU frequency switch completed, 
we can lower the runtimes to the new values;

   5b) we want to *decrease the CPU frequency*; unfortunately, here we 
need to proceed in the other way round: first, we need to increase the 
runtimes of the RT applications to the new values, then, as soon as 
we're sure all the scheduling servers made the change (waiting at most 
for a time equal to the maximum configured RT period), then we can 
actually perform the frequency switch. Of course, before switching the 
frequency, there's an assumption: that the new runtimes after the freq 
decrease are still schedulable, so the CPU freq switching logic needs to 
be aware of the allocated RT reservations.

The protocol in 5. has been implemented completely in user-space as a 
modification to the powernowd daemon, in the context of an extended 
version of a paper in which we were automagically guessing the whole set 
of scheduling parameters for periodic RT applications (EuroSys 2010). 
The modified powernowd was considering both the whole RT utilization as 
imposed by the RT reservations, and the non-RT utilization as measured 
on the CPU. The paper will appear on ACM TECS, but who knows when, so 
here u can find it (see Section 7.5 "Power Management"):

   http://retis.sssup.it/~tommaso/publications/ACM-TECS-2010.pdf

(last remark: no attempt to deal with multi-cores and their various 
power switching capabilities, on this paper . . .)

Last, but not least, the whole point in the above discussion is the 
assumption that it is meaningful to have a CPU frequency switching 
policy, as opposed to merely CPU idle-ing. Perhaps on old embedded CPUs 
this is still the case. Unfortunately, from preliminary measurements 
made on a few systems I use every day through a cheap power measurement 
device attached on the power cable, I could actually see that for RT 
workloads only it is worth to leave the system at the maximum frequency 
and exploit the much higher time spent in idle mode(s), except when the 
system is completely idle.

If you're interested, I can share the collected data sets.

Bye (and apologies for the length).

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso


--------------050508080508070906060206
Content-Type: text/x-chdr;
 name="frsh_energy_management.h"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="frsh_energy_management.h"

// -----------------------------------------------------------------------
//  Copyright (C) 2006 - 2009 FRESCOR consortium partners:
//
//    Universidad de Cantabria,              SPAIN
//    University of York,                    UK
//    Scuola Superiore Sant'Anna,            ITALY
//    Kaiserslautern University,             GERMANY
//    Univ. Politécnica  Valencia,           SPAIN
//    Czech Technical University in Prague,  CZECH REPUBLIC
//    ENEA                                   SWEDEN
//    Thales Communication S.A.              FRANCE
//    Visual Tools S.A.                      SPAIN
//    Rapita Systems Ltd                     UK
//    Evidence                               ITALY
//
//    See http://www.frescor.org for a link to partners' websites
//
//           FRESCOR project (FP6/2005/IST/5-034026) is funded
//        in part by the European Union Sixth Framework Programme
//        The European Union is not liable of any use that may be
//        made of this code.
//
//
//  based on previous work (FSF) done in the FIRST project
//
//   Copyright (C) 2005  Mälardalen University, SWEDEN
//                       Scuola Superiore S.Anna, ITALY
//                       Universidad de Cantabria, SPAIN
//                       University of York, UK
//
//   FSF API web pages: http://marte.unican.es/fsf/docs
//                      http://shark.sssup.it/contrib/first/docs/
//
//   This file is part of FRSH (FRescor ScHeduler)
//
//  FRSH is free software; you can redistribute it and/or modify it
//  under terms of the GNU General Public License as published by the
//  Free Software Foundation; either version 2, or (at your option) any
//  later version.  FRSH is distributed in the hope that it will be
//  useful, but WITHOUT ANY WARRANTY; without even the implied warranty
//  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details. You should have received a
//  copy of the GNU General Public License along with FRSH; see file
//  COPYING. If not, write to the Free Software Foundation, 675 Mass Ave,
//  Cambridge, MA 02139, USA.
//
//  As a special exception, including FRSH header files in a file,
//  instantiating FRSH generics or templates, or linking other files
//  with FRSH objects to produce an executable application, does not
//  by itself cause the resulting executable application to be covered
//  by the GNU General Public License. This exception does not
//  however invalidate any other reasons why the executable file might be
//  covered by the GNU Public License.
// -----------------------------------------------------------------------
//frsh_energy_management.h

//==============================================
//  ******** *******    ********  **      **
//  **///// /**////**  **//////  /**     /**
//  **      /**   /** /**        /**     /**
//  ******* /*******  /********* /**********
//  **////  /**///**  ////////** /**//////**
//  **      /**  //**        /** /**     /**
//  **      /**   //** ********  /**     /**
//  //       //     // ////////   //      // 
//
// FRSH(FRescor ScHeduler), pronounced "fresh"
//==============================================

#ifndef  _FRSH_ENERGY_MANAGEMENT_H_
#define  _FRSH_ENERGY_MANAGEMENT_H_

#include <time.h>

#include "frsh_energy_management_types.h"
#include "frsh_core_types.h"

FRSH_CPP_BEGIN_DECLS

#define FRSH_ENERGY_MANAGEMENT_MODULE_SUPPORTED       1

/**
 * @file frsh_energy_management.h
 **/

/**
 * @defgroup energymgmnt Energy Management Module
 *
 * This module provides the ability to specify different budgets for
 * different power levels.
 *
 * We model the situation by specifying budget values per power
 * level.  Thus switching in the power-level would be done by changing
 * the budget of the vres.  In all cases the period remains the same.
 *
 * All global FRSH contract operations (those done with the core
 * module without specifying the power level) are considered to be
 * applied to the higest power level, corresponding to a power_level_t
 * value of 0.
 *
 * @note
 * For all functions that operate on a contract, the resource is
 * implicitly identified by the contract core parameters resource_type
 * and resource_id that are either set through the
 * frsh_contract_set_resource_and_label() function, or implicitly
 * defined if no such call is made.
 *
 * @note
 * For the power level management operations, only
 * implementation for resource_type = FRSH_RT_PROCESSOR is mandatory,
 * if the energy management module is present.
 *
 * @{
 *
 **/



//////////////////////////////////////////////////////////////////////
//           CONTRACT SERVICES
//////////////////////////////////////////////////////////////////////


/**
 * frsh_contract_set_min_expiration()
 * 
 * This function sets the minimum battery expiration time that the
 * system must be able to sustain without finishing battery power. A
 * value of (0,0) would mean that the application does not have such
 * requirement (this is the default if this parameter is not explicitly
 * set).
 **/
int frsh_contract_set_min_expiration(frsh_contract_t *contract,
				     frsh_rel_time_t min_expiration);

/**
 * frsh_contract_get_min_expiration()
 * 
 * Get version of the previous function.
 **/
int frsh_contract_get_min_expiration(const frsh_contract_t *contract,
				     frsh_rel_time_t *min_expiration);

/**
 * frsh_contract_set_min_budget_pow()
 *
 * Here we specify the minimum budget value corresponding to a single
 * power level.
 *
 * @param contract		The affected contract.
 * @param power_level		The power level for which we are specifying the minimum budget.
 * @param pow_min_budget	The minimum budget requested for the power level.
 *
 * @return 0 if no error \n
 *	FRSH_ERR_BAD_ARGUMENT if power_level is greater than or equal to the value
 *	returned by frsh_get_power_levels  budget value is not correct.
 *
 * @note
 * If the minimum budget relative to one or more power levels has not been specified, then
 * the framework may attempt to perform interpolation of the supplied values in
 * order to infer them, if an accurate model for such operation is available.
 * Otherwise, the contract is rejected at frsh_negotiate() time.
 **/
int frsh_contract_set_min_budget_pow(frsh_contract_t *contract,
				     frsh_power_level_t power_level,
				     const frsh_rel_time_t *pow_min_budget);

/**
 * frsh_contract_get_min_budget_pow()
 *
 * Get version of the previous function.
 **/
int frsh_contract_get_min_budget_pow(const frsh_contract_t *contract,
				     frsh_power_level_t power_level,
				     frsh_rel_time_t *pow_min_budget);

/**
 * frsh_contract_set_max_budget_pow()
 *
 * Here we specify the maximum budget for a single power level.
 *
 * @param contract		The affected contract object.
 * @param power_level		The power level for which we are specifying the maximum budget.
 * @param pow_max_budget	The maximum budget requested for the power level.
 *
 * @return 0 if no error \n
 *        FRSH_ERR_BAD_ARGUMENT if any of the pointers is NULL or the
 *             budget values don't go in ascending order.
 *
 **/
int frsh_contract_set_max_budget_pow(frsh_contract_t *contract,
				     frsh_power_level_t power_level,
				     const frsh_rel_time_t *pow_max_budget);

/**
 * frsh_contract_get_max_budget_pow()
 *
 * Get version of the previous function.
 **/
int frsh_contract_get_max_budget_pow(const frsh_contract_t *contract,
				     frsh_power_level_t power_level,
				     frsh_rel_time_t *pow_max_budget);


/**
 * frsh_contract_set_utilization_pow()
 *
 * This function should be used for contracts with a period of
 * discrete granularity.  Here we specify, for each allowed period,
 * the budget to be used for each power level.
 *
 * @param contract	The affected contract object.
 * @param power_level	The power level for which we specify budget and period.
 * @param budget	The budget to be used for the supplied power level and period.
 * @param period	One of the allowed periods (from the discrete set).
 * @param period	The deadline used with the associated period (from the discrete set).
 **/
int frsh_contract_set_utilization_pow(frsh_contract_t *contract,
				      frsh_power_level_t power_level,
				      const frsh_rel_time_t *budget,
				      const frsh_rel_time_t *period,
				      const frsh_rel_time_t *deadline);

/**
 * frsh_contract_get_utilization_pow()
 *
 * Get version of the previous function.
 **/
int frsh_contract_get_utilization_pow(const frsh_contract_t *contract,
				      frsh_power_level_t power_level,
				      frsh_rel_time_t *budget,
				      frsh_rel_time_t *period,
				      frsh_rel_time_t *deadline);


//////////////////////////////////////////////////////////////////////
//           MANAGING THE POWER LEVEL
//////////////////////////////////////////////////////////////////////

/**
 * frsh_resource_set_power_level()
 *
 * Set the power level of the resource identified by the supplied type and id.
 *
 * @note
 * Only implementation for resource_type = FRSH_RT_PROCESSOR is mandatory,
 * if the energy management module is present.
 **/
int frsh_resource_set_power_level(frsh_resource_type_t resource_type,
				  frsh_resource_id_t resource_id,
                                  frsh_power_level_t power_level);

/**
 * frsh_resource_get_power_level()
 *
 * Get version of the previous function.
 **/
int frsh_resource_get_power_level(frsh_resource_type_t resource_type,
				  frsh_resource_id_t resource_id,
                                  frsh_power_level_t *power_level);

/**
 * frsh_resource_get_speed()
 *
 * Get in speed_ratio representative value for the speed of the specified
 * resource, with respect to the maximum possible speed for such resource.
 *
 * @note
 * Only implementation for resource_type = FRSH_RT_PROCESSOR is mandatory,
 * if the energy management module is present.
 **/
int frsh_resource_get_speed(frsh_resource_type_t resource_type,
			    frsh_resource_id_t resource_id,
			    frsh_power_level_t power_level,
			    double *speed_ratio);

/**
 * frsh_resource_get_num_power_levels()
 *
 * Get the number of power levels available for the resource identified
 * by the supplied type and id.
 *
 * @note
 * The power levels that may be used, for the identified resource,
 * in other functions through a power_level_t type, range from 0
 * to the value returned by this function minus 1.
 *
 * @note
 * The power level 0 identifies the configuration with the maximum
 * performance (and energy consumption) for the resource.
 *
 * @note
 * Only implementation for resource_type = FRSH_RT_PROCESSOR is mandatory,
 * if the energy management module is present.
 */
int frsh_resource_get_num_power_levels(frsh_resource_type_t resource_type,
				       frsh_resource_id_t resource_id,
				       int *num_power_levels);

//////////////////////////////////////////////////////////////////////
//           BATTERY EXPIRATION AND MANAGING POWER LEVELS
//////////////////////////////////////////////////////////////////////

/* /\** IS THIS NEEDED AT ALL ? I GUESS NOT - COMMENTED */
/*  * frsh_resource_get_battery_expiration() */
/*  * */
/*  * Get the foreseen expiration time of the battery for the resource */
/*  * identified by the supplied type and id. */
/*  * */
/* int frsh_battery_get_expiration(frsh_resource_type_t resource_type, */
/* 				 frsh_resource_id_t resource_id, */
/* 				 frsh_rel_time_t *expiration); */

/**
 * frsh_battery_get_expiration()
 *
 * Get the foreseen expiration time of the system battery(ies).
 **/
int frsh_battery_get_expiration(frsh_abs_time_t *expiration);

/*@}*/

FRSH_CPP_END_DECLS

#endif 	    /* _FRSH_ENERGY_MANAGEMENT_H_ */

--------------050508080508070906060206--
