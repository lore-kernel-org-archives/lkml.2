Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab2CBNSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:18:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2CBNSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:18:04 -0500
Message-ID: <4F50C86E.3010305@redhat.com>
Date: Fri, 02 Mar 2012 10:17:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab> <4F4E145E.4040901@redhat.com> <20120229121914.GD21224@aftab> <4F4E22B1.6020505@redhat.com> <20120229133741.GF21224@aftab> <4F4EDD9A.4050900@jp.fujitsu.com> <20120301114023.GB32410@aftab> <3908561D78D1C84285E8C5FCA982C28F040ACC@ORSMSX104.amr.corp.intel.com> <4F504645.5040708@jp.fujitsu.com>
In-Reply-To: <4F504645.5040708@jp.fujitsu.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-03-2012 01:02, Hidetoshi Seto escreveu:
> (2012/03/02 3:28), Luck, Tony wrote:
>>>> My concern is; on Sandy Bridge, is it safe to gather info about the DIMM
>>>> location in/from machine check context in a reasonable time span?
>>>
>>> Well, what amd64_edac does is "buffer" the required lookup info so
>>> whenever you get an error, you simply lookup the channel and chip select
>>> - all ops which can be done in atomic context.
>>
>> Yes - we could pre-read all the config space registers ahead of time and
>> save them in memory (none of the values should change - except if the platform
>> supports hot-plug for memory). Total is only a few Kbytes. Then decode in
>> machine check context is both safe, and fast.
> 
> To sort out my thought:
> 
>  - First of all, OS gathers info about physical location of DIMMs from
>    DMI/ACPI/PCI etc., before enabling MCE mechanism.
>  - Make a kind of "physical memory location table" on memory buffer,
>    to ease mapping a physical address to the location of a DIMM module
>    and/or chip which have the memory cell pointed by the address.
>     - It would be better to have a well organized table rather than
>       having a raw copy of config space etc.
>     - Likewise it will also nice if we can map logical processor numbers
>       to the location of physical sockets on motherboard.

If you take a look at the SB driver, my original idea was do to it: there's a
routine there (get_memory_layout) that parses all PCI registers used to describe
the memory.

On my preliminary versions, I was storing their contents into the private data.

About the same logic is duplicated at get_memory_error_data(), which is the function
that actually parses the memory error. In the past, it was using the cached
data.

I ended by removing the cache due to a few reasons:

	- how to detect and re-run the get_memory_error_data() when memory is
hot-plugged?

	- I had to re-write the logic several times, as I was discovering more
things about the SB. Writing a more clever/faster logic for storing the data
for each new change were taking too much time;

	- While I never tried to measure the performance of that logic, I
suspect that the performance benefits may not justify the cache;

	- It was more important to have something work, than a very optimized
driver;

	-  Paraphrasing Blaise Pascal, "I have made the decoding logic slower, 
	   because I have not had the time to make it faster".

Feel free to write some patches to optimize it.

>     - Happy if user can refer the table via sysfs.

Representing the logic via sysfs is not easy, due to interlacing. Sandy
Bridge has several ways to interlace memories, among their channels, plus
arranging the address on NUMA/non-NUMA mode. The way it is represented
internally is complex to understand.

I would love to find a way to tell the user that addresses between
x and y belongs to DIMM z, but, due to certain interlace modes, this
would be a very complex task.

>     - Allow updating the table if the platform supports hot-plug.

This change is not trivial. The EDAC core requires to allocate the memory at
the beginning. 

Not sure if it is easy to support hot-plug there. It will likely need to
receive a hot-plug event, and call some routine that would call a memory
discovery callback.

If is there any MCA event for memory hot-plug, it sounds feasible.

>  - Once MCE is enabled, handler can refer the table on memory to
>    determine an erroneous device which should be replaced.

MCE enabled is a requirement for the SB driver:

config EDAC_SBRIDGE
	tristate "Intel Sandy-Bridge Integrated MC"
	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL

> This storyline up to here is reasonable and acceptable, I think.
> 
> Then now it is clear that the last point where I feel uneasy about is
> putting a string into the ring buffer instead of binary bits like index
> of location table.  Please use binary (or "binary + string") to tell
> the error location to userland.

I agree with you that merging everything into a single string is very bad,
and this is the main point we're discussing.

Let me make a summary of the status.

As you know, there are two types of location (silkscreen label and the
location itself, as recognized internally by the hardware. 

I'm fixing the EDAC core, as it is currently not able to handle the real
location, and requires that everything to be converted into a per-rank
memory description (csrow/channel), with doesn't work for most non-legacy 
drivers.

The EDAC core provides a way to convert from location into the silkscreen label.

Basically, there's a sysfs node with the dimm label, with is filled at
the machine boot time, via the edac utils. 

Depending on the driver, the location, can actually be:
	branch/channel/slot	=> DIMM
	channel/slot		=> DIMM
	csrow/channel		=> DIMM rank

The patch series I'm working add a way for the driver to tell the core what of 
the above applies, and, when an error occurs, it allows the driver to tell 
exactly on what location the error happened [1].


[1] With the upstream version, the "location" is a meaningless, fake information,
    on all Intel non-legacy drivers (i5xxx edac drivers, i7core_edac, sb_edac).


It is possible to use the internal representation I've added on it, storing
them on a binary way, and exporting as such to userspace.

Borislav is arguing against it, for MCA based events, as such kind of 
representation would require a memory-specific tracepoint.

For non-MCA events, there's not much problems, as there aren't many types
of errors.

In the end, we have a few alternatives, and no consensus was reached with regards
to it.

The alternatives for MCA errors are either to use a single tracepoint for all
hardware types, forcing the driver/core to convert the internal binary representation
into a string, or to have multiple traces for hardware errors.

Three different strategies were actually proposed:

1) Everything goes into a single string (Borislav's patchset [2]);

2) A memory error specific tracepoint, plus other tracepoints for other types of
errors (my patch [3]).

3) An hybrid alternative, splitting the severity, location and silk_screen label from
the error message (my proposal, no patch for it yet [4]). As the location there
should be independent of the type of the hardware, it has to be a string.


[2] https://lkml.org/lkml/2012/2/28/280

[3] http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=4eb2a29419c1fefd76c8dbcd308b84a4b52faf4d

[4] https://lkml.org/lkml/2012/2/29/187


Looking at the existing code, what happens with regards to location is that there
are currently two types of location:

a) a memory location (could be 2 or 3 integers);

b) a CPU location (one integer).

Internally, for each trace, a printk string should be defined, like:

TP_printk("%s error %s on \"%s\" (location: %s)",
	  __get_str(msg),
	  __get_str(label),
	  __get_str(location))

It is easy to write such macro for strings, but doing it for a variable-length
location field would likely require more work.

A binary way to represent the memory location would be as an array, whose size is
specified by a parameter, or with an structure that would have a location name, value
pair, like:

struct {
	char *name;
	int value;
} key_value_pair mem_location[] = {
	{ "csrow", 0},
	{ "channel", 1},
};

I don't think that trace as some trace macro that would allow to  print something like
that, currently. Not sure how easy/difficult do add support for it at perf, on both
kernelspace and userspace.

Regards,
Mauro
