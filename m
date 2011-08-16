Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1HPTuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:50:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61503 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1HPTux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hba3PgTQjaWCmqQCgiaPnvdcOPd1VrQio-X-NY__T7HmA@mail.gmail.com>
References: <1313441856-1419-1-git-send-email-wad@chromium.org>
	<20110816093303.GA4484@csn.ul.ie>
	<CAB=4xhqu1FsJnNbHNeokyROvEFpRJYKhcHRLLw5QTVKOkbkWfQ@mail.gmail.com>
	<20110816194050.GB4484@csn.ul.ie>
	<CABqD9hba3PgTQjaWCmqQCgiaPnvdcOPd1VrQio-X-NY__T7HmA@mail.gmail.com>
Date: Tue, 16 Aug 2011 14:50:52 -0500
Message-ID: <CABqD9hauSAYsDgXeJBajqdc07qY6qz1bFpPGCZnPKTTZGJjmWw@mail.gmail.com>
Subject: Re: [PATCH] mmap: add sysctl for controlling ~VM_MAYEXEC taint
From: Will Drewry <wad@chromium.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Roland McGrath <mcgrathr@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Hugh Dickins <hughd@google.com>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 2:50 PM, Will Drewry <wad@chromium.org> wrote:
> On Tue, Aug 16, 2011 at 2:40 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> On Tue, Aug 16, 2011 at 10:07:46AM -0700, Roland McGrath wrote:
>>> On Tue, Aug 16, 2011 at 2:33 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>>> > Is using shm_open()+mmap instead of open()+mmap() to open a file on
>>> > /dev/shm really that difficult?
>>> >
>>> > int shm_open(const char *name, int oflag, mode_t mode);
>>> > int open(const char *pathname, int flags, mode_t mode);
>>>
>>> I cannot figure out the rationale behind this question at all.
>>> Both of these library functions result in the same system call.
>>>
>>
>> They might result in the same system call but one of them creates
>> the file under /dev/shm which should not have the same permissions
>> problem. The library really appears to want to create a shared
>> executable object, using shm_open does not appear that unreasonable
>> to me.
>
> If /dev/shm is mounted noexec, the resulting file will have VM_MAYEXEC

Err VMA from mmaping the file from shm_open().

> stripped.  I don't believe it is capable of doing anything special
> that will cause the mmap code path to find a different containing
> mountpoint.  If it could, then that would certainly be preferable, but
> it would also make this VM_MAYEXEC calculation less effective in the
> default case.
>
> thanks!
>
>>> > An ordinary user is not going to know that a segfault from an
>>> > application can be fixed with this sysctl. This looks like something
>>> > that should be fixed in the library so that it can work on kernels
>>> > that do not have the sysctl.
>>>
>>> I think the expectation is that the administrator or system builder
>>> who decides to set the (non-default) noexec mount option will also
>>> set the sysctl at the same time.
>>>
>>
>> Which then needs to be copied in each distro wanting to do the same
>> thing and is not backwards compatible where as using shm_open is.
>>
>> --
>> Mel Gorman
>> SUSE Labs
>>
>
