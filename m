Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0I2Lmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0I2Lmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:42:35 -0400
Message-ID: <4CA32626.8040700@redhat.com>
Date: Wed, 29 Sep 2010 13:42:30 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Matthew Wilcox <matthew@wil.cx>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: fix numbering in /proc/locks
References: <4CA0B4A5.1090701@redhat.com> <4CA0B743.2050801@parallels.com>
In-Reply-To: <4CA0B743.2050801@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 05:24 PM, Pavel Emelyanov wrote:
> On 09/27/2010 07:13 PM, Jerome Marchand wrote:
>>
>> The lock number in /proc/locks (first field) is implemented by a counter
>> (private field of struct seq_file) which is incremented at each call of
>> locks_show(). Currently it is reset each time locks_start() is called,
>> that is each time we call the read() syscall on /proc/locks. Because of
>> that, the numbering erratically restarts at 1 several times when reading
>> a long /proc/locks file.
>> We want the counter to be initialized at opening time and then never
>> reset until we close the file. Fortunately, seq_open() memzeros the
>> seq_file structure, so we can just drop the reset in locks_start() and
>> move the increment the counter before actually printing the line so the
>> numbering still starts at 1.
> 
> IMHO the implementation is wrong. If you want the proper sequence number
> while file is open you should increase on in the ->next callback of the
> seq_ops, not in show.

Good point. My implementation is definitely wrong. But I'm afraid that
moving the increment in locks_next() won't help either. It will fail when
a program do something more than just read the file sequentially (use
of lseek() for instance). We need a better way to keep track of the
current position in the list.

Thanks,
Jerome

