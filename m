Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2CNT0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab2CNT0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:26:20 -0400
Message-ID: <4F60F0D7.70505@redhat.com>
Date: Wed, 14 Mar 2012 16:26:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Add a sysfs node to test the EDAC error report
 facility
References: <1331122101-28382-1-git-send-email-mchehab@redhat.com> <20120313233138.GA31106@kroah.com>
In-Reply-To: <20120313233138.GA31106@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-03-2012 20:31, Greg KH escreveu:
> On Wed, Mar 07, 2012 at 09:08:21AM -0300, Mauro Carvalho Chehab wrote:
>> Even on memory controllers that have memory injection, such functionality
>> can be disabled by BIOS during bootstrap, and it may not be possible to
>> enable it via BIOS setup.
>>
>> So, as not all hardware supports error injection, add a mechanism to
>> allow testing the edac driver and the core.
>>
>> This feature is only enabled when EDAC_DEBUG is equal to Y, so there's no
>> extra code for the production Kernels.
> 
> Then please move it to debugfs, where debugging stuff belongs.

There are other edac error injection tools at sysfs. That's why I opted to keep
it there - plus, I was too lazy[1] to learn about the debugfs bits at the time I
wrote it, and adding a single node to sysfs were very trivial ;)

[1] In a matter of fact, testing this patchset is too time-consuming,
as it required me to get access to several systems, including some old ones.
This patch in particular were written in order to help me with the tests.
While I intend to improve it, this has lower priority than the tests themselves,
the discussions about the patches/ABI and the media maintainer stuff.

> 
> At the least, you need to document all sysfs files in Documentation/ABI/

Yes, this is on my TODO list. I'll document it at the Documentation on the
final patchset.

Btw, the current EDAC sysfs API is not documented there at ABI/, but,
instead, at Documentation/edac.txt. What is there is basically the sysfs node
description, but it is more verbose than what is there at Documentation/ABI.

I'm not sure what would be the better to do there: to move everything into
Documentation/ABI, to keep edac.txt as is (of course, adding there the new
nodes) or to keep a simplified edac.txt file and add a more concise
description at Documentation/ABI.

While there's current no plans to remove the existing EDAC sysfs API, when
writing the documentation patch, it is probably a good idea to put the
nodes that provide duplicated information at Documentation/ABI/obsolete.

> 
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>
>> NOTE: This patch should be applied after the series that add proper support for
>> FB-DIMM, due to context changes.
>>
>>  drivers/edac/edac_mc_sysfs.c |   62 ++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/edac.h         |    4 +++
>>  2 files changed, 64 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
>> index 870ccb0..f538f9e 100644
>> --- a/drivers/edac/edac_mc_sysfs.c
>> +++ b/drivers/edac/edac_mc_sysfs.c
>> @@ -744,6 +744,42 @@ static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data,
>>  	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
>>  }
>>  
>> +#ifdef CONFIG_EDAC_DEBUG
>> +static ssize_t edac_fake_inject_show(struct mem_ctl_info *mci,
>> +				     char *data, void *priv)
>> +{
>> +	return sprintf(data,
>> +		       "EDAC fake test engine. Writing to this node a value in the form of :\n"
>> +		       "\t0:1:0\n"
>> +		       "will call the EDAC core routine to produce a memory error for the given memory location (0, 1, 0).\n"
>> +		       "The driver's error parsing logic won't be tested. This tool is useful only\n"
>> +		       "if you're testing the EDAC core tracing facility, or if you're needing to test\n"
>> +		       "some userspace application.\n");
>> +}
> 
> Ick, no NEVER do this for a sysfs file, even for "debugging", that's
> what debugfs is for, please move this file there, this isn't ok.
> 
> Again, sysfs is "one value per file".

Ok. I won't add this patch on my linux-next tree after finishing the tests. I'll keep
it on my todo list and re-write it later, when I find some time to convert it into
debugfs.

> 
> thanks,
> 
> greg k-h

