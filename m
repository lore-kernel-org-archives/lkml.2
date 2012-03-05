Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2CEMUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:20:49 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:39605 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756561Ab2CEMUs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:20:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eduardo.valentin@ti.com designates 10.182.86.201 as permitted sender) smtp.mail=eduardo.valentin@ti.com
MIME-Version: 1.0
In-Reply-To: <20120305101827.GA19408@khazad-dum.debian.net>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
	<1330647453.1916.7.camel@ymzhang>
	<20120302142303.648285a7.akpm@linux-foundation.org>
	<C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
	<4F545A4E.8010801@linux.vnet.ibm.com>
	<4F5466C4.2090808@intel.com>
	<20120305101827.GA19408@khazad-dum.debian.net>
Date: Mon, 5 Mar 2012 14:20:46 +0200
Message-ID: <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH V3] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


On Mon, Mar 5, 2012 at 12:18 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 05 Mar 2012, ShuoX Liu wrote:
>> @@ -45,6 +46,7 @@ total 0
>>  /sys/devices/system/cpu/cpu0/cpuidle/state1:
>>  total 0
>>  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
>> +-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
>>  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
>>  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
>>  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
>
> ...
>
>> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
>> index 3fe41fe..1eae29a 100644
>> --- a/drivers/cpuidle/sysfs.c
>> +++ b/drivers/cpuidle/sysfs.c
>> @@ -222,6 +222,9 @@ struct cpuidle_state_attr {
>>  #define define_one_state_ro(_name, show) \
>>  static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444,
>> show, NULL)
>>
>> +#define define_one_state_rw(_name, show, store) \
>> +static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644,
>> show, store)
>> +
>>  #define define_show_state_function(_name) \
>>  static ssize_t show_state_##_name(struct cpuidle_state *state, \
>>                        struct cpuidle_state_usage *state_usage, char *buf) \
>> @@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
>> cpuidle_state *state, \
>>       return sprintf(buf, "%u\n", state->_name);\
>>  }
>>
>> +#define define_store_state_function(_name) \
>> +static ssize_t store_state_##_name(struct cpuidle_state *state, \
>> +             const char *buf, size_t size) \
>> +{ \
>> +     int value; \
>> +     sscanf(buf, "%d", &value); \
>> +     if (value) \
>> +             state->disable = 1; \
>> +     else \
>> +             state->disable = 0; \
>> +     return size; \
>> +}
>
> Isn't this missing a check for capabilities?  Disabling cpuidle states is
> not something random Joe (and IMHO that does mean random capability-
> restricted Joe root) should be doing...
>
> Also, maybe it would be best to use one of the lib helpers to parse that
> value, so that it will be less annoying to userspace (trim blanks, complain
> if there is trailing junk after trimming, etc)?

I may be jumping the thread in the middle but, if it is for debug
purposes, as states the subject, shouldn't this entry go to debugfs
instead of sysfs? I know cpuidle has all the infrastructure there to
simply add another sysfs entry, but if the intent is to create a debug
capability, then I'd say it fits under debugfs instead.  Adding Greg
KH here, as I suppose he may have strong opinion on using sysfs for
debugging.

Of course, if you are targeting user space control over C states on
production  systems, then it's a different thing then.

>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm



-- 

Eduardo Valentin
