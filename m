Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1CKXqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 18:46:03 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:41345 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1CKXqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 18:46:00 -0500
Message-ID: <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
In-Reply-To: <201103111255.44979.arnd@arndb.de>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
Date: Sat, 12 Mar 2011 00:45:47 +0100 (CET)
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: "Indan Zupancic" <indan@nul.nu>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Sage Weil" <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Jonathan Nieder" <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 4b95630a2805109a2fafe329e7ec4fd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, March 11, 2011 12:55, Arnd Bergmann wrote:
> On Friday 11 March 2011, Indan Zupancic wrote:
>> >       http://marc.info/?l=linux-fsdevel&amp;m=127970513829285&amp;w=2
>>
>> The patch there seems much more reasonable than introducing a whole
>> new systemcall just for 20 lines of kernel code. New system calls are
>> added too easily nowadays.
>
> The only problem with adding new system calls is that we are stuck
> with the interface until the end of time, so we must be sure not
> to get it wrong. The same thing is true for any other interface
> such as ioctl or extensions to existing system calls. People usually
> get away with adding new ioctls more easily because it is less
> obvious when they are added.

Agreed.

I'm not sure this feature is important enough to add. I can't really
think of a regular use case where this would be useful, generally
it's transparent on which mount files are. Add symlinks, and you
give users a lot of rope. Any user has to make sure that all the
files they want to sync are on the same file system.

About the arguments against sync(2):

>  - On machines with many mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).

It would be better to fix NFS, or mount it with the fsc option (assuming
a sync will write to the local cache instead of hanging forever then).

>  - Some applications write lots of data to the file system and then
>    want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.

You can use sync_file_range() on those files to schedule the writes
and then do the fsync(2) as usual (both on files and dirs).

If there still is a good reason to implement this, please don't add it
as a new system call, but add it to sync_file_range(), as that seems
the best place for odd file synchronisation operations.

Greetings,

Indan


