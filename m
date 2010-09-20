Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0ITU2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:28:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50279 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab0ITU2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100920185001.GA955@redhat.com>
References: <20100917152639.0e88341a@basil.nowhere.org>
	<1284736618-27153-2-git-send-email-wad@chromium.org>
	<20100918012939.GA25046@redhat.com>
	<AANLkTimsNtoT2GGCv1Zk2cGCsZ17zsOqV1DiF7D5tV=L@mail.gmail.com>
	<20100920185001.GA955@redhat.com>
Date: Mon, 20 Sep 2010 15:28:52 -0500
Message-ID: <AANLkTikRurUqfPmJ_GWqG5XvvMzgUHt0yac7QN-pNkpX@mail.gmail.com>
Subject: Re: [PATCH 2/2] exec: move core_pattern pipe helper into the crashing namespace
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 1:50 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/17, Will Drewry wrote:
>>
>> On Fri, Sep 17, 2010 at 8:29 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > This looks overcomplicated to me, or I missed something.
>> >
>> > I do not understand why should we do this beforehand, and why we need
>> > copy_namespaces_unattached().
>> >
>> > Can't you just pass current to umh_pipe_setup() (or another helper) as
>> > the argument? Then this helper can copy ->fs and ->nsproxy itself.
>>
>> I wasn't sure if it was reasonable to pass the current task_struct
>> over, but I certainly can.
>
> Why not? current calls call_usermodehelper_exec(), it can't go away
> until subprocess_info->init() returns, it sleeps on wait_for_completion().

yeah - I wasn't sure because the other coredump_params didn't pass it,
so I assumed there was some history around that.  Though it sounds
like the current approach may not be the way forward anyhow.

>> In practice, this seems to amount to just adding a refcount to all the
>> namespaces and creating a new nsproxy which isn't really needed.  Most
>> likely, doing what you've suggested above plus the copy_fs_struct and
>> the swap out will do the trick.  I'll try it out and see.  That's make
>> it much clearer I think.
>
> Yes, just get_nsproxy() (like fork() does) should be fine in this case.
>
> As for copying ->fs, I am not sure actually. core_pattern is global,
> say it is "|/coredumper". If you change ->root, then exec can fail
> because that binary is not visible to the coredumping process?

Yeah - it's lose-lose I think.  On one hand, it may not run, on the
other hand it may have access where it shouldn't or not have access it
where it needs it.

> Probably we should move core_pattern into ->pid_ns, I dunno.

Sounds like this is worth doing. I'll look into it and post something
for further consideration!
thanks again -
will
