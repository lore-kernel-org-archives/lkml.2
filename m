Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1LRMiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 07:38:00 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47909 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1LRMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 07:37:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111214211652.GO2203@ZenIV.linux.org.uk>
References: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
	<20111214211652.GO2203@ZenIV.linux.org.uk>
Date: Sun, 18 Dec 2011 20:37:55 +0800
Message-ID: <CAE04G=BvDFrAu2SoY5sQ9XjoFh9g2kp-gbzO0ETC2i4XMqi0AQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Add process memory layout to coredump file
From: t cheney <cdmalord@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        gdb-patches@sourceware.org, binutils@sourceware.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/11, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Dec 10, 2011 at 10:37:02PM +0800, t cheney wrote:
>> This patch just add memory layout(same as /proc/pid/maps) to
>> coredump file. The layout is appended to corenote segment with
>> flag NT_MAPS=7.
>
>> +		len = sprintf(buf, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu",
>> +			start,
>> +			end,
>> +			flags & VM_READ ? 'r' : '-',
>> +			flags & VM_WRITE ? 'w' : '-',
>> +			flags & VM_EXEC ? 'x' : '-',
>> +			flags & VM_MAYSHARE ? 's' : 'p',
>> +			pgoff,
>> +			MAJOR(dev), MINOR(dev), ino);
>
> Device numbers may be wider than 16 bits.
Yes, it should be:
len = sprintf(buf, "%08lx-%08lx %c%c%c%c %08llx %03x:%05x %lu",
and  corresponding change from 25 to 29 in function pad_spaces:
static int pad_spaces(char *p, int len)
{
       len = 29 + sizeof(void *) * 6 - len;

>
>> +			p = d_path(&vma->vm_file->f_path, s, maps_size-1);
>
> What if somebody renames the file (or, better yet, its parent directory)
> between two calls of that thing?
>
Yes, function core_handle_maps is called twice, first one just calculate size,
second one write maps into coredump file. If the pathname is changed,
the size may changed too.
If the new size is less than or same as origin, all maps string is
written to file.
If the new size is  more than  origin, just part is written to file,
the rest is ignored.
