Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1IADH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:07:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49873 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab1IADH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:07:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110831151023.5b7e12da.akpm@linux-foundation.org>
References: <20110831075814.003575573@openvz.org> <20110831080229.100652529@openvz.org>
 <20110831090612.GA3253@albatros> <20110831112642.GI25465@sun>
 <20110831140416.GA17626@shutemov.name> <20110831142622.GB30615@sun> <20110831151023.5b7e12da.akpm@linux-foundation.org>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 31 Aug 2011 23:07:05 -0400
Message-ID: <CAGZ=bqLE8uJj+m-LZM1OX093M+0aE6+zxJF0o5DPHOnYX3iA5A@mail.gmail.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vasiliy Kulikov <segoon@openwall.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 18:10, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 31 Aug 2011 18:26:22 +0400  Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> This one behaves similarly to the /proc/<pid>/fd/ one - it contains symlinks
>> one for each mapping with file, the name of a symlink is "vma->vm_start-vma->vm_end",
>> the target is the file. Opening a symlink results in a file that point exactly
>> to the same inode as them vma's one.
>>
>> For example the ls -l of some arbitrary /proc/<pid>/map_files/
>>
>>  | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80403000-7f8f80404000 -> /lib64/libc-2.5.so
>>  | lr-x------ 1 root root 64 Aug 26 06:40 7f8f8061e000-7f8f80620000 -> /lib64/libselinux.so.1
>>  | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80826000-7f8f80827000 -> /lib64/libacl.so.1.1.0
>>  | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a2f000-7f8f80a30000 -> /lib64/librt-2.5.so
>>  | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a30000-7f8f80a4c000 -> /lib64/ld-2.5.so
>
> This particular patch introduces a distressing amount of duplication of
> /proc/pid/maps.  The changelog should provide a really good
> justification for doing this: why is /proc/pid/maps (and smaps!)
> unsuitable and why cannot maps/smaps be fixed to be suitable?

Andrew,

This is way more useful than /proc/$PID/maps, because this allows you
to reliably obtain an FD to an arbitrary mapped memory segment.

EG:
  $ cp /bin/sleep ~/my-sleep
  $ ~/my-sleep 1000 & kid=$!
  $ rm ~/my-sleep
  $ mkdir ~/mapped_files
  $ for file in /proc/$kid/map_files/*; do cp "$file" ~/mapped_files/; done

This trivially gets me copies of every mapped file, including the deleted
"my-sleep" binary, it also trivially handles lazy-unmounted filesystems,
chroots, namespaces, and all sorts of similar kernel cleverness.

It's exactly the same kind of utility that /proc/$PID/fd/* has, but for
mmap().

With /proc/$kid/maps you simply can't work around some of those
kinds of issues (IE: deleted files, etc).

Cheers,
Kyle Moffett
