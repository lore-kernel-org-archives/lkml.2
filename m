Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1K1LDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:03:35 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49960 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1K1LDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:03:33 -0500
Message-ID: <4ED36A7D.9070308@linux.vnet.ibm.com>
Date: Mon, 28 Nov 2011 16:33:25 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.power-management.general,gmane.linux.ports.ppc64.devel,gmane.linux.kernel
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] cpuidle: (POWER) Handle power_save=off
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>	<20111117112906.9191.54050.stgit@localhost6.localdomain6> <1322435233.23348.19.camel@pasglop>
In-Reply-To: <1322435233.23348.19.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112801-5140-0000-0000-000000542F2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 04:37 AM, Benjamin Herrenschmidt wrote:

> On Thu, 2011-11-17 at 16:59 +0530, Deepthi Dharwar wrote:
>> This patch makes pseries_idle_driver not to be registered when
>> power_save=off kernel boot option is specified. The
>> boot_option_idle_override variable used here is similar to
>> its usage on x86.
> 
> Quick Q. With your changes, the CPU will never get into idle at all
> until cpuidle initializes and the driver loads.
> 
> That means not only much later in the boot process, but potentially
> never if the distro has the driver as a module and fails to load it, or
> similar.
> 
> Can't that be an issue ? Shouldn't we keep at least one of the basic
> idle functions as a fallback ?
> 


On an LPAR if cpuidle is disabled, ppc_md.power_save is still set to
cpuidle_idle_call by default here. This would result in calling of
cpuidle_idle_call repeatedly, only for the call to return -ENODEV. The
default idle is never executed.
This would be a major design flaw. No fallback idle routine.

We propose to fix this by checking the return value of
ppc_md.power_save() call from void to int.
Right now return value is void, but if we change this to int, this
would solve two problems. One being removing the cast to a function
pointer in the prev patch and this design flaw stated above.

So by checking the return value of ppc_md.power_save(), we can invoke
the default idle on failure. But my only concern is about the effects of
changing the ppc_md.power_save() to return int on other powerpc
architectures. Would it be a good idea to change the return type to int
which would help us flag an error and fallback to default idle?

> Cheers,

> Ben.
> 
> 


Regards,
Deepthi

