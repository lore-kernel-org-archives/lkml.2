Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2ADL0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 06:26:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39145 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2ADL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 06:26:38 -0500
Date: Wed, 4 Jan 2012 15:26:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 2/4] proc: Show namespaces IDs in /proc/pid/ns/* files
Message-ID: <20120104112632.GH2621@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.725686255@openvz.org>
 <m1d3b0gg3r.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d3b0gg3r.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 10:02:32PM -0800, Eric W. Biederman wrote:
> Cyrill Gorcunov <gorcunov@openvz.org> writes:
> 
> > This patch adds proc_ns_read method which provides
> > IDs for /proc/pid/ns/* files.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> This is a poorly thought out user interface.  If we are going to return
> this kind of information and I believe we should we should, we should
> return the id in the inode field with stat.
> 
> Comparing device+inode for equality is the traditional way to see if
> two objects are the same in unix and there is no reason to make up
> a new interface to get this functionality.
> 
> Furthermore we should always return the information, as it is valuable
> even outside of the checkpoint/restart context.
> 
> I am also concerned that you appear to be building an interface
> for use by checkpoint/restart that makes it impossible
> checkpoint/restart the programs using that interface.  The reason
> is that you appear to be  putting this nebulous id into a global 
> namespace and as such even if we wanted to I don't see how we could
> build a version where we could restore the id during a restart.  And
> the thing is if you start building interfaces with identifiers you can
> not possibly restore I expect you will find you have painted yourself
> into a corner.
> 
> Using inode from stat avoids painting yourself into a corner because
> you have the possibility of different mounts with different device
> numbers having different inode numbers.
> 
> For the short term I don't see value in being able to restore the
> object identifiers, but I do see a lot of value in allowing for a future
> where nested checkpoint/restart is an option.
> 
> Eric
>

Hi Eric, thanks a lot for comments! I must admit I never though about
nested checkpoint/restore simply because even plain and direct CR still
has a number of problems which are not yet addressed.

As to return such ID in ino field (if I understand you right -- you
propose to return such ID as inode of kstat structure) -- I don't think
it would be right either. Instead of one iteface applied to all objects
we export there will be a few different approaches instead -- for net-ns
it would be dev+ino, for tasks and other members of task-structure
it'll be IDs from /proc (as implemented in another patches). I like
more Kyle's idea about object_id() call which would simply return the
entrypted ID to user-space and it'll be up to user-space to do anything
it wants with such pieces of information.

Yes, there will be no way to restore such IDs later but the interface
is not supposed to work this way. All this mess only because of lack
of way to figure out which task resources are shared and which are not.
Maybe if we can carry CLONE_ flags from copy_process()/unshare()/setns()
(and which else modify task resources?) inside task_struct and provide
these flags back to user-space we might not need the IDs helpers at all.
But I think such approach might end up in a pretty big patch bloating
the kernel. In turn I wanted to bring as minimum new functionality as
possible *with* a way to completely turn it off if user don't need it.

	Cyrill
