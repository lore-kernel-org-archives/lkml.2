Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2LGXSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:18:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51584 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2LGXSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:18:39 -0500
Date: Fri, 7 Dec 2012 15:18:29 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config
 groups
Message-ID: <20121207231828.GM22789@localhost>
Mail-Followup-To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Nazarewicz <mina86@mina86.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
 <50B39921.6090308@linutronix.de>
 <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
 <50B4E364.8030704@linutronix.de>
 <xa1tip8ruia5.fsf@mina86.com>
 <50B5C821.4000406@linutronix.de>
 <xa1ta9u1naik.fsf@mina86.com>
 <50B61695.50207@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B61695.50207@linutronix.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,
	Sorry I missed this for a while.  I'll make a couple of inline
comments, and then I'll summarize my (incomplete) thoughts at the
bottom.

On Wed, Nov 28, 2012 at 02:50:13PM +0100, Sebastian Andrzej Siewior wrote:
> On 11/28/2012 02:05 PM, Michal Nazarewicz wrote:
> >>On 11/27/2012 05:23 PM, Michal Nazarewicz wrote:
> >>>How should a generic tool know what kind of actions are needed for given
> >>>function to be removed?  If you ask me, there should be a way to unbind
> >>>gadget and unload all modules without any specific knowledge of the
> >>>functions.  If there is no such mechanism, then it's a bad user
> >>>interface.

	Please remember that configfs is not a "user" interface, it's a
userspace<->kernelspace interface.  Like sysfs, it's not required to be
convenient for someone at a bash prompt.  My goal is that it is *usable*
from a bash prompt.  So it must be that you can
create/destroy/configure objects via mkdir/rmkdir/cat/echo, but you
might have a lot of those mkdir/echo combos to configure something.
When it comes to the "user" interface, a wrapper script or library
should be converting a user intention into all that boilerplate.

> >
> >On Wed, Nov 28 2012, Sebastian Andrzej Siewior wrote:
> >>Well. You need only to remove the directories you created.
> >
> >My point is that there should be a way to write a script that is unaware
> >of the way function is configured, ie. which directories were created
> >and which were not.

	As I stated above, I expect that tools will know which is which.
But having said that, a major goal of configfs is that it is discoverable and
transparent.  So you have to be able to distinguish between default
groups and created directories.  When you rmdir a configfs directory,
EACCESS means you don't have permission, ENOTEMPTY means there are children,
EBUSY means there is a depend or a link, and EPERM means it is a default
group.

> I get this. If you recursively rmdir each directory then you clean it
> up.
> 
> >Besides, if you rmdir lun0, is the function still supposed to work with
> >all LUNs present?  In my opinion, while gadget is bound, it should not
> >be possible to modify such things.
> 
> That is correct. The configuration should remain frozen as long as the
> gadget is active because in most cases you can't propagate the change.
> 
> >>An unbind would be  simply an unlink of the gadget  which is linked to
> >>the udc.   All configurations  remain so  you can link  it at  a later
> >>point without touching the configuration because it is as it was.
> >
> >Yes, but that's not my concern.  My concern is that I should be able to
> >put a relatively simple code in my shutdown script (or whatever) which
> >unbinds all gadgets, without knowing what kind of functions are used.
> >
> >And I'm proposing that this could be done by allowing user to just do:
> >
> >	cd /cfs/...
> >	rmdir gadgets/*		# unbind and remove all gadgets
> >	rmdir functions/*/*	# unbind and remove all function instances
> >	rmdir functions/*	# unload all functions
> 
> Yes, you push for simple rmdir API. That would avoid the need for an
> user land tool at some point and you end up in shell scripts.
> I'm not against it but others do have user tools to handle such things.

	Yeah, user tools are expected (and should be).

> Anyway, for this to work we have to go through Joel.
> 
> >	rmdir udcs/*		# unload all UDCs
> 
> No, for this you still have to rmmod :)
> 
> 
> >>>I think the question is of information flow direction.  If user gives
> >>>some information to the kernel, she should be the one creating any
> >>>necessary directories.  But if the information comes from kernel to the
> >>>user, the kernel should create the structure.

	This last paragraph actually describes the distinction between
configfs and sysfs.  More specifically, if userspace wants to create an
object in the kernel, it should use configfs.  If the kernel has created
an object on its own, it exposes it via sysfs.  It is a deliberate
non-goal for configfs to replicate sysfs behavior.

[General Thoughts]

	First let me restate your problem to see if I understand it.
	You want to expose e.g. five LUNs.  They should eventually appear
in configfs as five items to configure (.../{lun0,lun1,...lun4}/.  The
current configfs way to do this is to have your setup script do:

	cd /cfg/.../mass_storage
	mkdir lun0
	echo blah >lun0/attr1
	echo blahh >lun0/attr2
	mkdir lun1
	echo blag >lun1/attr1
	echo blagg >lun1/attr1
	...

I think the primary concern expressed by Andrzej is that a random user
could come along and say "mkdir lun8", even though the gadget cannot
support it.  A secondary concern from Michal is that userspace has to
run all of those mkdirs.  The thread has described varying solutions.
	If these original directories were default_groups, you could
disallow any child creation and not require the setup script to create
directories.  Here I will point out that you *can* create default_groups
programmatically.  The default_groups pointer on each configfs_group
can be different.  ->make_group() can attach whatever groups it wants.
If this would work, it would fit both of your concerns, but you do not
have a priori knowledge of the LUN count.
	Your original email proposed that the max lun be set like so:

	cd /cfg/.../mass_storage
	echo 5 >luns_allowed

There are then a couple of proposed ways to enforce the limit.  Your
->create_group() idea wants luns_allowed to be able to create subdirs in
the ->store() function.  No ->mkdir() is provided, so a lunN cannot be
created by hand.
	The ->create_group() idea has three challenges.  First, it
creates "default" groups *after* the object is created.  This makes no
sense if they are attributes of the toplevel object.  Second, it volates
the configfs mantra that user-generated objects are explicitly created.
The kicker, however, is the technical problem.  configfs explicitly
forbids tree changes inside attribute operations for deadlock reasons.
Trying to create new tree parts in luns_allowed->store() is exactly
that.
	Another suggestion (I think I read this in the thread) would be
to have ->mkdir() function parse the name and check that it is lunN,
where N is less than the limit.  I think that this was shot down because
of parsing the LUN name.  I don't think that's too terrible, but there's
certainly room for argument.

[Possible Solutions]

	Before coming back to the proposed patch, let's look at what I
might do if I were fitting this into configfs.
	I would actually do what I described at first:

	cd /cfg/.../mass_storage
	mkdir lun0
	echo blah >lun0/attr1
	...

This is idiomatic configfs usage.  Sebastian noted this earlier in the
thread.  Michal thought the repeated mkdirs were a problem ("I think
that's suboptimal, and we can do better").  This is Michal's objection
to making the user do work.  This is where I point out we are not
designing configfs interfaces for ease of end-user use.  We're defining
them for transparent and discoverable interfaces for tools to create
things in the kernel.  So the repeated mkdir()s are actually a good
thing from my perspective; userspace is telling the kernel to create LUN
objects.
	But this doesn't alleviate Andrzej's primary concern, nor does
it answer Michal's concerns about corner cases.  Let's see if we can
solve those.
	First, what about preventing extraneous LUNs?  There are two
approaches: the prevent approach, and the ignore approach.  In the
Target module, they take the ignore approach.  If you create a LUN that
is outside the scope, they just ignore it.  So a user can make 10 LUNs,
but if only five are allowed, the other five are ignored.  In the
prevent approach, we try to fail the mkdir() when we go over the limit.
	So you've set a limit with "echo 5 >luns_allowed".  How do you
restrict?  If you don't care about contiguous LUN numbering, you could
literally do this in your make_group():

	if (count_luns(parent) >= parent->luns_allowed)
		return -ENOSPC;

Note that we don't check the LUN number; SCSI does not require
contiguous numbering.  It does require LUN 0, which should probably be a
default group.  So your lun count starts at 1.
	What if you decide you really want contiguous LUN numbers, which
is considered nice to have?  Then we get to Michal's concern about
parsing the name.  If you "mkdir lun1", the code has to confirm that it
a) starts with "lun", b) finishes with a parsable number, c) that number
is < luns_allowed.
	But you need to do the parsing anyway!  If the LUN is created
via mkdir(), somehow the gadget system needs to know what LUN number to
advertise.  I would actually decouple it from the name.  The name should
be free-form; if it happens to be comprehensible, that's good.  Imagine
this:
	cd /cfg/.../mass_storage
	echo 4 >max_lun_id
	mkdir lun100
	echo 1 >lun100/lun_id

The LUN actually has the ID of 1.  The fact that the directory name is
wrong is irrelevant to the gadget processing; non-hackers use the
tooling, and the tooling should  make sane names.  Then your
->make_group() function can choose either approach to avoiding LUN IDs
that are too large.  It can prevent:

	lun_id->store() {
		if (lun_id_exists(parent, value))
			return ERR_PTR(-EINVAL);
		if (value > parent->max_lun_id)
			return ERR_PTR(-ENOSPC) /* or EINVAL */
		setup_lun();
		make_live();
	}

Or it can ignore:

	lun_id->store() {
		if (lun_id_exists(parent, value))
			return ERR_PTR(-EINVAL);
		if (value <= parent->max_lun_id) {
			setup_lun();
			make_live();
		}
		/* Do nothing for the ignored sucker */
	}

	I think that I, personally, would go with this <name>/lun_id
scheme.  Given a requirement for contiguous LUNs and the max_lun_id
restriction, I'd go with the "prevent" option myself.
	But is max LUNs a requirement?  Why not just have the LUN count
be the number of LUNs created?  In that case, you can allow or disallow
discontiguous LUN IDs without worrying about a max ID.

[Really Hate Mkdir]

	If you considered it appropriate for the LUN objects to be
created by the kernel, the standard way would to have
"echo 5 >luns_allowed" create LUN objects in sysfs.  Yes, sysfs.
There's no reason you can't have things in configfs *and* sysfs.  My
understanding of your code says to me that the mkdir approach is the way
to go, but if you hate it, this works.

[What About the Patch?]

	In general, attribute setting that turns into created configfs
objects is against the theory of configfs.  In practice, it's a
nightmare locking change.  Coming into this discussion, I though you
were doing dymanic things at ->make_group() time, but that is already
supported.
	But I want to hear your thoughts.  I've dumped a bunch of
alternate approaches here.  Do any seem to fit?  What other challenges
do you see?

Joel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

			http://www.jlbec.org/
			jlbec@evilplan.org
