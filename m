Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab1LPINx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:13:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39040 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1LPINv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:13:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Benjamin LaHaise <bcrl@kvack.org>
References: <CAPLs8y9omncDbLE_KNoKOLLbfwHjWYUJX_i7cC4bLiJsyPbtZQ@mail.gmail.com>
Date: Fri, 16 Dec 2011 00:15:26 -0800
In-Reply-To: <CAPLs8y9omncDbLE_KNoKOLLbfwHjWYUJX_i7cC4bLiJsyPbtZQ@mail.gmail.com>
	(Lucian Adrian Grijincu's message of "Mon, 5 Dec 2011 09:55:31 +0200")
Message-ID: <m1obv9rkyp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18/oVDPq60bkRNDMaGsG4ZAImCC+N9ErHY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: v6: faster tree-based sysctl implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bringing this back on list because my reply is a design discussion and
that has every reason to be public.

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:
> On Thu, Dec 8, 2011 at 2:19 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Which is my cue to say that I am behind the power curve in reviewing
> > this.  I will see if I can get to this before the end of the week.
> 
> 
> Did you had time to take a look over the code?

Not as much time as I would have liked.  However I have looked at it
some and I have brought back some of the state from my head so I
can remember where we last at in the conversation.

> I'm inclined to do a bit of redesign: currently files are kept in
> lists of files and sub-directories in a rbtree; I'd like to put
> everything in a rbtree and make things simpler.

I like the idea of putting everything in an rbtree. And
I like the idea of making things simpler.

> But I'd first like some sort of feedback from you. I wouldn't like to
> spend time working on something only to be told that the base idea of
> the reworking is unacceptable and everything needs to be rewritten.

As things stand I don't think your changes really solve the problem.
At least not if your change log can be believed.

> = New algorithm =
> 
> == Time complexity ==
> 
> - registration of N headers. Registration means adding new directories
>   at each level or incrementing an existing directory's refcount.
> 
>   - O(N * lnN) - if the paths to the headers are evenly distributed
> 
>   - O(N^2) - if most of the headers registered are children of the
>     same parent directory (searching the list of subdirs takes O(N)).
>     There are cases where this happens (e.g. registering sysctl
>     entries for net devices under /proc/sys/net/ipv4|6/conf/device).

This worries me because this is the case that we really care about.

>     A few later patches will add an optimisation, to fix locations
>     that might trigger the O(N^2) issue.

Is it your rb directory tree patch that addresses this?

....

My big concerns.
- I don't want to inflict churn on the users of sysctl unless we are
  certain it will gain us something.

- I really would like to see the core become simple enough that
  non-sysctl experts can look at the code and understand what is going
  on.

It doesn't look like your design has achieved sufficient simplicity yet
so that a non sysctl expert can look the code and understand what is
going on and why.

....

There are two very worthwhile things I see us doing with this patchset.
- Moving the users of sysctl to full directory semantics.
- Improving the data structures so that the data structures are
  efficient.

....

*** Moving the users of sysctl to full directory semantics. ***

As I have been watching the code sysctl has been moving from
a custom union filesystem (where each ctl_table was unioned
together) to normal filesystem semantics.   The last hold out
for union semantics are directories.

The truly weird case in this is "/proc/sys/fs/binfmt_misc/" an empty
directory for mounting the "binfmt_misc" filesystem on.

Which means that fundamentally we need a way to create, remove and
represent empty directories.  So while it is attractive to be lazy
and handle directories with some variant of lazy semantics creating
them when needed and deleting them when there is nothing left in the
directory I don't believe that will work.

Currently sysctl directories live under a relaxed version of the normal
fs rules:
- A directory must be created we can create children in it.
- A directory may not be deleted before we can remove children from it.

Since we in theory already have this strong property I don't see a
benefit of killing the sysctl .child table entry in the beginning of
the patchset.    It means a lot of churn and a lot more code to review
without giving us more useful properties.  Furthermore it retains the
clumsy ctl_path structure, which now that we don't need to add ctl_names
is a very clumsy structure to use.  A normal pathname would be better.

So initially I think at most we want to enhance sysctl_check to verify
that we retain normal directory create and remove discipline with the
current sysctl users.

....

*** Improving the internal sysctl data structures ***

With that the simplest way I can see of dealing with the sysctl data
structures is simply replace our current internal kernel data structures
with something that we want to use, with a compatibility layer from
the current users of sysctl to what we want to see.

My guess is that we would like to have a data structure like:
struct proc_sysctl_dirent {
	struct ctl_table *table; /* Point to the original ctl_table */
        struct rb_node	rb_node;
        struct rb_root  children;
        atomic_t count;
};

That is not perfect but I think building a data structure like that
without changing the userspace interface might actually reduce the
line count of sysctl, and drastically reduce the challenge of
understanding the code.

In a perfect world we might even want to use proc_dir_entry for the
new data structure but that is probably more complication than it is
worth right now.

My biggest concern is how do we handle the duplication of directories
that comes with the network namespace?   There are some weird things
in there.

....

Lucian is that anything like what you were thinking?

Does just improving the sysctl data structures and treating ctl_table
and it's kin as just a weird interface the callers use sound like it
might be a feasible path to you?

Eric
