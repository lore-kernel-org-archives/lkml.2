Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0KWIHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:07:45 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59480 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0KWIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KnqxvPoJEVOo2nCI33PbA+UL9v3AUeuWxmAV/baCq8AsxeFJPuQw3Gf82FdU4rS+oC
         NkCqUW2KAbVJTI59IRG+9/kstPg2XQS2qMZQwRS2NknIRgpWirIf9EwmFb52etiTAyMS
         YxOvVtzbAPKUdlzb8JxtopwXotKoT43gjYyrY=
Message-ID: <4CEB7648.8030000@gmail.com>
Date: Tue, 23 Nov 2010 00:07:36 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Bcache version 9
References: <20101121140808.GA6429@moria> <20101122010914.GB7688@kroah.com>
In-Reply-To: <20101122010914.GB7688@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2010 05:09 PM, Greg KH wrote:
> On Sun, Nov 21, 2010 at 06:09:34AM -0800, Kent Overstreet wrote:
>> +++ b/Documentation/bcache.txt
>
> For new sysfs files, please create Documentation/ABI files.
>
>> +All configuration is done via sysfs. To use sde to cache md1, assuming the
>> +SSD's erase block size is 128k:
>> +
>> +  make-bcache -b128k /dev/sde
>> +  echo "/dev/sde">  /sys/kernel/bcache/register_cache
>> +  echo "<UUID>  /dev/md1">  /sys/kernel/bcache/register_dev
>
> /sys/kernel/bcache/?  Really?

That was a completely arbitrary choice dating from when I first started 
hacking on it. No point in moving it when it might be moved again :p

> Come on, shouldn't this be somewhere else?  You only have 1 file here,
> right?

Two files (really three, but the third is for gimpy latency tracing and 
will die eventually). register_dev is there so on bootup you don't have 
to wait for the cache to be discovered - when you add a cache device if 
there's a backing device waiting for a cache, and the cache has seen 
that UUID before it'll do what you want.

> Shouldn't it be a configfs file instead as that is what you are doing?

That was one of the possibilities I had in mind. My main issue with that 
though is I don't see any way to just have a bare config_item - per the 
documentation, the user must do a mkdir() first, which just doesn't make 
any sense for bcache. There's no point in having a persistent object 
besides the one associated with the block device. Maybe there would be 
in the future, with multiple cache devices, but I still think it's a 
lousy interface for that problem - what bcache wants is something more 
like a syscall; you wouldn't use configfs to replace mount(), for example.

There do exist global interfaces in sysfs, not attached to any device - 
besides /sys/kernel, there's /sys/fs which doesn't have any rhyme or 
reason to it I can discern. ecryptfs has /sys/ext4/ecryptfs/version, 
ext4 has per device stuff that you can't find from the device's dir (you 
woludn't know /sys/fs/ext4/md0 exists from looking at /sys/block/md0). 
There's also /sys/fs/cgroup, which is another unique thing as far as I 
can tell...

Then there's /sys/module which has a bunch of ad hoc stuff, but as far 
as I can tell that's all still module parameters and register_cache and 
register_dev certainly aren't module parameters.

So anyways, I absolutely agree that there are better solutions than 
/sys/kernel/bcache but I want to replace it with something correct, not 
something that sucks less. Ideas/flames are of course more than welcome :)
