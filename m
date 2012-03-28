Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2C1B4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 21:56:51 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:51994 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755483Ab2C1B4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 21:56:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
References: <20120313005855.GA24639@redhat.com>
	<CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
	<20120318192755.GB6589@ZenIV.linux.org.uk>
	<CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
	<m1vclw1fx8.fsf@fess.ebiederm.org>
	<CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
	<m1iphuu9pd.fsf_-_@fess.ebiederm.org>
	<CAMOw1v65TePmMOxzGsnW4xv1ge1RDD=Stxgo9-eqtyi8hdjZOQ@mail.gmail.com>
	<m1ty1esa52.fsf@fess.ebiederm.org>
	<CAMOw1v4hZFk20QzvwWUL73Nax2m77HOkfp0KkuOPFjCgYprZgw@mail.gmail.com>
	<20120327010253.26e5087f@vader>
Date: Tue, 27 Mar 2012 19:00:23 -0700
In-Reply-To: <20120327010253.26e5087f@vader> (Lucas De Marchi's message of
	"Tue, 27 Mar 2012 01:02:53 -0300")
Message-ID: <m1mx71o56w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX180QsbnOm1yLtFnFg8PMR9VmU9HJiPwBoM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Lucas De Marchi <lucas.demarchi@profusion.mobi>
X-Spam-Relay-Country: **
Subject: Re: [REVIEW][PATCH] Making poll generally useful for sysctls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:

> On Mon, 26 Mar 2012 14:44:50 -0300
> Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:
>
>> Hi Eric,
>> 
>> On Sat, Mar 24, 2012 at 4:58 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>
>> > Here is rebased version of the patch just in case that helps.
>> 
>> Now I can apply, but I can't boot: we hit a NULL dereference in
>> __wake_up_common(), called by proc_sys_poll_notify(). It seems that
>> you forgot to initialize the waitqueue with
>> __WAIT_QUEUE_HEAD_INITIALIZER().
>
> Trying again I came up with the following simple oneliner on top
> of your patch. With it I can boot successfully and poll any file
> under /proc/sys (I didn't try many, but there's no reason it would not
> work).

Thanks. I feel silly for that pretty obvious oversight.

There is another bug I am seeing in the sysctl poll code.  It needs to
be .read that updates filp->private_data to event, and not .poll.
Otherwise we have what should be a level triggered interface acting like
an edge triggered interface.

Any chance I could get you to cook up a patch for that bug?

> The nice part of this patch is that suddenly all sysctl entries can be
> monitored through poll() instead of having to add adhoc code. However
> that spurious wake ups are not very nice. Eric, what if we keep the
> waitqueue inside the entry and initialize it there, just like we did
> for ->event? This would mean iterating through them on unregister
> though.

Iterating through the all of the table entries on unregister is
not a problem, some code paths for namespace support are doing that
already.  Putting the wait queue in struct ctl_table is something
we can't do.  struct ctl_table can be freed before the final fput
on a file descriptor and fs/select.c will try to remove freed
wait queue heads, which would get us back to where we came in.

What we can do is use struct ctl_node instead. Either bloating struct
ctl_node or adding putting a pointer to struct ctl_table_poll.  The
only tricky part is that I don't believe I have any size information
on how many ctl_node entries I have.  So that information would have
to be gathered and kept as well.

After having looked at how large wait_queue_head_t I am reluctant
to pay the price for keeping a wait queue for nodes that we are not
polling.  So I am thinking allocate in .poll and free in unregister,
but I don't think I am ambitious enough to code that up.

Eric
