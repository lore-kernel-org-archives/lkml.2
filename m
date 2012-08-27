Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab2H0J4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 05:56:08 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56164 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2H0J4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 05:56:06 -0400
Message-ID: <503B43D6.2080509@linux.vnet.ibm.com>
Date: Mon, 27 Aug 2012 15:24:30 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org, ananth@in.ibm.com,
        Chris McDermott <lcm@us.ibm.com>, masbock@linux.vnet.ibm.com
Subject: Re: [PATCH] x86: mce: Honour bios-set CMCI threshold
References: <20120822123054.29238.3864.stgit@localhost.localdomain> <20120822124649.GD5817@aftab.osrc.amd.com> <50361A59.2020308@linux.vnet.ibm.com> <20120827091235.GB26602@aftab.osrc.amd.com>
In-Reply-To: <20120827091235.GB26602@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082709-8256-0000-0000-000003E783F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 02:42 PM, Borislav Petkov wrote:
> On Thu, Aug 23, 2012 at 05:26:09PM +0530, Naveen N. Rao wrote:
>> Sure - sounds like a good idea. Further, a #define could eliminate
>> the need to change other references, but I'm not sure that's
>> GENERALLacceptable
>>
>> #define mce_bios_cmci_threshold boot_flags.mce_bios_cmci_threshold
>>
>> could eliminate the need to change other references, but I'm not sure
>> that's acceptable
>
> Yeah, that's kinda obfuscating it for no reason. As I said before, we
> can always add it later if it makes sense.

Ouch!
This was an old draft and I'm not sure how this ended up on the list!
Sorry for all the trouble.

>
>> But, I just had a quick look and it seems to me that these were
>> defined as integers since they are exposed via sysfs. For instance:
>>
>> static struct dev_ext_attribute dev_attr_cmci_disabled = {
>>          __ATTR(cmci_disabled, 0644, device_show_int, set_cmci_disabled),
>>          &mce_cmci_disabled
>> };
>>
>> Converting mce_cmci_disabled to a bit-field doesn't work since we
>> take its address above. We could ignore and not set the second field
>> at all (dev_ext_attribute->var) and define our own callbacks, but
>> that'll be more work and I'm not sure if we work fine without
>
> Right,
>
> but take a look at set_cmci_disabled(): it converts the newly read value
> to bool anyway:
>
>          if (mce_cmci_disabled ^ !!new) {
>
> so we can do later
>
> 	flags.mce_cmci_disabled = true;
>
> or
> 	flags.mce_cmci_disabled = false;
>
> instead of assigning 0 or 1 to it.
>
> And, about showing it with device_show_int, a simple test works:
>
> ---
> #include <stdio.h>
> #include <stdbool.h>
>
> int main()
> {
>          bool a = true;
>          printf("%d\n", a);
>          return 0;
> }
> --
>
> but even if there are troubles with that, we can change device_show_int
> to a locally defined function.
>
> But, anyway, long story short: I wasn't suggesting you go and change all
> of them - simply start by adding your flag mce_bios_cmci_threshold to a
> struct <something>_flags and I'll take care of the rest.
>
> Unless you really want to do it, of course :-)

Sure, I'll send a patch for this soon.


Regards,
Naveen

>
> Oh, and the more important thing is, Tony would need to review your
> Intel-specific changes so pls keep him CCed on your next iteration too.
>
> Thanks.
>

