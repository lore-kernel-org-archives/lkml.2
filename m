Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014Ab2CMAmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:42:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59571 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758927Ab2CMAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:42:34 -0400
X-Sasl-enc: 4yLGdGEuA15fZr1vmXtUBLc2U8+lgHWs/twbPVaWRPLO 1331599352
Date: Mon, 12 Mar 2012 21:42:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH V3] cpuidle: Add a sysfs entry to disable specific C
 state for debug purpose.
Message-ID: <20120313004229.GA21111@khazad-dum.debian.net>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
 <1330647453.1916.7.camel@ymzhang>
 <20120302142303.648285a7.akpm@linux-foundation.org>
 <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
 <4F545A4E.8010801@linux.vnet.ibm.com>
 <4F5466C4.2090808@intel.com>
 <20120305101827.GA19408@khazad-dum.debian.net>
 <1330995854.1916.39.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330995854.1916.39.camel@ymzhang>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2012, Yanmin Zhang wrote:
> On Mon, 2012-03-05 at 07:18 -0300, Henrique de Moraes Holschuh wrote:
> > On Mon, 05 Mar 2012, ShuoX Liu wrote:
> > > @@ -45,6 +46,7 @@ total 0
> > >  /sys/devices/system/cpu/cpu0/cpuidle/state1:
> > >  total 0
> > >  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
> > > +-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
> > >  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
> > >  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
> > >  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
> > 
> > ...
> > 
> > > diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> > > index 3fe41fe..1eae29a 100644
> > > --- a/drivers/cpuidle/sysfs.c
> > > +++ b/drivers/cpuidle/sysfs.c
> > > @@ -222,6 +222,9 @@ struct cpuidle_state_attr {
> > >  #define define_one_state_ro(_name, show) \
> > >  static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444,
> > > show, NULL)
> > > 
> > > +#define define_one_state_rw(_name, show, store) \
> > > +static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644,
> > > show, store)
> > > +
> > >  #define define_show_state_function(_name) \
> > >  static ssize_t show_state_##_name(struct cpuidle_state *state, \
> > >  			 struct cpuidle_state_usage *state_usage, char *buf) \
> > > @@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
> > > cpuidle_state *state, \
> > >  	return sprintf(buf, "%u\n", state->_name);\
> > >  }
> > > 
> > > +#define define_store_state_function(_name) \
> > > +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> > > +		const char *buf, size_t size) \
> > > +{ \
> > > +	int value; \
> > > +	sscanf(buf, "%d", &value); \
> > > +	if (value) \
> > > +		state->disable = 1; \
> > > +	else \
> > > +		state->disable = 0; \
> > > +	return size; \
> > > +}
> > 
> > Isn't this missing a check for capabilities?  Disabling cpuidle states is
> > not something random Joe (and IMHO that does mean random capability-
> > restricted Joe root) should be doing...
> Sorry. Could you elaborate it?

Sure.  Should any user be able to disable a C state, therefore causing
the system to consume more power?

I am pretty sure the answer is NO, in which case you should check for
the appropriate user credentials before you allow a write to these
"debug" controls to succeed.  "capability" here is one of the CAP_*
capabilities tested through capable(), which are supposed to limit even
root.

> > Also, maybe it would be best to use one of the lib helpers to parse that
> > value, so that it will be less annoying to userspace (trim blanks, complain
> > if there is trailing junk after trimming, etc)?
> We would use strict_strtol to parse the value in next version.

Thanks!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
