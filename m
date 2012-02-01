Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2BAB0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:26:19 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48203 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2BAB0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:26:17 -0500
Message-ID: <4F289486.2050107@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 17:25:26 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com> <1327674868-10486-1-git-send-email-jolsa@redhat.com> <1327674868-10486-6-git-send-email-jolsa@redhat.com> <4F231256.8080905@linux.vnet.ibm.com> <20120130095223.GB1552@m.brq.redhat.com>
In-Reply-To: <20120130095223.GB1552@m.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020101-3270-0000-0000-000003A3B864
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 01:52 AM, Jiri Olsa wrote:
> On Fri, Jan 27, 2012 at 01:08:38PM -0800, Corey Ashford wrote:
>> On 01/27/2012 06:34 AM, Jiri Olsa wrote:
>>> Adding sysfs group 'format' attribute for pmu device that
>>> contains a syntax description on how to construct raw events.
>>>
>>> The event configuration is described in following
>>> struct pefr_event_attr attributes:
>>>
>>>   config
>>>   config1
>>>   config2
>>>
>>> Each sysfs attribute within the format attribute group,
>>> describes mapping of name and bitfield definition within
>>> one of above attributes.
>>>
>>> eg:
>>>   "/sys/...<dev>/format/event" contains "config:0-7"
>>>   "/sys/...<dev>/format/umask" contains "config:8-15"
>>>   "/sys/...<dev>/format/usr"   contains "config:16"
>>>
>>> the attribute value syntax is:
>>>
>>>   line:      config ':' bits
>>>   config:    'config' | 'config1' | 'config2"
>>>   bits:      bits ',' bit_term | bit_term
>>>   bit_term:  VALUE '-' VALUE | VALUE
>>>
>>> Adding format_defined bool to the struct pmu to specify wether
>>> pmu defines its own set of format attributes (within the
>>> attr_groups member) or the default format attributes should be
>>> used:
>>>   "/sys/...<dev>/format/config"  contains "config:0-63"
>>>   "/sys/...<dev>/format/config1" contains "config1:0-63"
>>>   "/sys/...<dev>/format/config2" contains "config2:0-63"
>>
>>
>> Hi Jiri,
>>
>> I've been out of the perf_events loop for some time, but I did finally
>> notice your patch series thread.
>>
>> I think what you've done is very good and I'm excited to see progress in
>> this area.  However, it's not clear to me that it is as generalized as
>> it needs to be for some PMU's.  I say this because not all events on a
>> given PMU will have the same needed fields.
> 
> ok, I wasn't aware of this
> 
>>
>> As an example, the IBM PowerEN processor has roughly 20 different PMU's
>> on it.  Some of those PMU's are quite complex and divide their events up
>> into subsets, each with different fields.  For example, some events may
>> have a PID matching field, and others may have an bus number matching
>> field, or matching mode field, etc.  The fields are different widths,
>> and may overlap in the config/1/2 space.
>>
>> It seems that there are two approaches you could take:
>>
>> 1) Keep your format, but allow the fields to overlap in the bit space.
>> For example:
>>
>>   "/sys/...<dev>/format/event" contains "config:0-7"
>>   "/sys/...<dev>/format/pidmatch" contains "config:8-15"
>>   "/sys/...<dev>/format/busmatch"   contains "config:8-13"
>>
>> Note that busmatch overlaps pidmatch
> 
> currently format fields definitions may overlap, there's no check
> to prevent that
> 
>>
>> 2) Create event groups that have their overlapping config space
>> separated out:
>>
>>   "/sys/...<dev>/format/event" contains "config:0-7"
>>
>>   "/sys/...<dev>.1/format/pidmatch" contains "config:8-15"
>>
>>   "/sys/...<dev>.2/format/busmatch"   contains "config:8-13"
>>
>>
>> Notice the .1 and .2 on the <dev>.
>>
>> This might help the user understand which fields go together.  I'm not
>> sold on the .1 syntax... you could do it as <dev>.<event-group-name>/ or
>> <dev>/<event-group-name>/... or whatever seems to make the most sense
>> and is relatively easy to implement and use.
> 
> Though I'm not sure we want allow separate devices inside single pmu,
> I think we could have multiple format groups if necessary :)
> 
> some quick ideas:
> 
> 1) having format group attribute under format like:
>    <dev>/format/group1/..
>    <dev>/format/group2/..
>    <dev>/format/group2/..
>    ...
> 
> 2) having format group name within the format attribute name like:
>    <dev>/format/group1-krava1
>    <dev>/format/group1-krava2
>    <dev>/format/group2-krava3
>    ...
> 
> 3) having group name inside the foramt attributes like:
>    cat <dev>/format/group1-krava1
>    group1 config:0-1,62-63
> 
> 
> I think I like the most ad 1)..
> 
> We could have something like default format directory if there's
> only a single format group, like:
>    <dev>/format/default/krava1
>    <dev>/format/default/krava2
>    ...
> 
> The perf event syntax could have something like '::' to classify
> format attribute with a group like (none would go to default dir):
> 
>    cpu/group1::config=1,group2::config1=2,config2=3/u

The "[::<group>|]" syntax is good.

Are you are suggesting that a single event could use multiple groups
because they may share some common fields, such as the event code?  If
so, I think that might be confusing.   I think it would be better to
have every group fully lay out the bits in the config{,1,2} fields so
that you only need to specify one group per event, even if that leads to
some redundancy (e.g. group1..n all have an eventcode field.)

Something I missed before is that your config sysfs attribute group can
look like:

config1:0-1,62-63

How does the user specify a value for these two bit fields, or does he
concatenate the bit fields together, and perf will split it apart again?
e.g. cpu/group1::config1=1,2/u   ?


> or 
>    cpu::group1/config=1,config1=2,config2=3/u
> 
> 
> Or we could say the format field names could not overlap and then
> we dont need to specify group at all :) It'd be just for user's
> awareness..

perf would then "want" to check for overlap and also for fields coming
from different groups.  In some cases, I think you'd want to have the
same name for a field, but have the field a different size, or perhaps a
different interpretation.   For example "busid" might be a desirable
name for fields in two different event groups, but their sizes and
position are different.  Of course the quick fix is to name them
uniquely, but since they are in subdirectories, it isn't really obvious
that the names have to be unique.

One other comment that occurs to me is that it would be nice for perf to
know when a supplied value is out of range, or will have undefined
results.  For example, a field may be 8 bits wide, but not all 8-bit
values are legal.  For example, there may be 208 events, and the codes
may be somehwhat or even very sparsely encoded.  So, ideally, a config
field in sysfs might look like this:

config1:0-7:0x0-0xd8,0xdb-0xe2,0xe4-0xe6

This way perf could check for valid values before stuffing them into
registers, and give a good error message to the user.  If there is no
restriction field, it would be assumed all of the possible values are valid.

I think the kernel code needs to check for bad values as well, because
people can bypass the restrictions exposed by sysfs and use the
perf_events API directly.


- Corey

