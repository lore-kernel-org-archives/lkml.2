Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1KATrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:47:17 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:57590 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1KATrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=HK52vSMzFzYcy/RoueElG68h+r9Qgget
	mm1rulXL3vy6n0TzrU3k+/Vm1Z0F2OYTy2M49DmQjtVPWt2/Es2gWTeXyZbW/WiC
	BFKCMaq27gvP6mM8uoIA3aca9zz41VKMb8msKVVwXcMIo6m66b0eKn19MV98z3m4
	hWj5nokM7Qk=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org>
 <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
Date: Tue, 01 Nov 2011 12:47:12 -0700
In-Reply-To: <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com> (Linus
 Torvalds's message of "Mon, 31 Oct 2011 15:18:28 -0700")
Message-ID: <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 4BAA93FE-04C2-11E1-9782-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> But what would be nice is that "git pull" would fetch the tag (based on
> name) *automatically*, and not actually create a tag in my repository at
> all. Instead, if would use the tag to check the signature, and - if we
> do this right - also use the tag contents to populate the merge commit
> message.
>
> In other words, no actual tag would ever be left around as a turd, it
> would simply be used as an automatic communication channel between the
> "git push -s" of the submitter and my subsequent "git pull". Neither
> side would have to do anything special, and the tag would never show
> up in any relevant tree (it could even be in a totally separate
> namespace like "refs/pullmarker/<branchname>" or something).

While I like the "an ephemeral tag is used only for hop-to-hop
communication to carry information to be recorded in the resulting
history" approach, I see a few downsides.

 * The ephemeral tag needs to stay somewhere under refs/ hierarchy of the
   lieutenant's tree until you pick it up, even if they are out of the way
   in refs/pullmarker/$branchname. The next time the same lieutenant makes
   a pull request, either it will be overwritten or multiple versions of
   them refs/pullmarker/$branchname/$serial need to be kept.

   - If the former, this makes forking of the project harder. Suppose a
     pull request is made, you fetch and reject it. The lieutenant reworks
     and makes another pull request. At this point the earlier signature
     is gone. If somebody disagreed with your rejection and wanted to run
     his tree with the initial version you rejected, his tree will not
     carry the signature from the lieutenant.

   - If the latter, then there needs to be a way to expire these pull
     markers when they no longer are useful (i.e. the signature in it is
     transcribed to a merge commit you create) [*1*]. But the party who
     has power to clean them (i.e. the lieutenant who owns the repository)
     is different from the party whose action determines when they no
     longer are necessary (i.e. you). In practice this would lead to these
     pull markers not cleaned at all [*2*].

 * To verify the commit C that was taken from the tip of lieutenant's tree
   some time ago, one has to find the merge commit that has C as a parent,
   and look at the merge commit.  For example "git log --show-signature"
   would either show or not show the authenticity of C depending on where
   the traversal comes from. You certainly can implement it that way, but
   "some child describes an aspect of its parent, but not necessarily all
   children do so" feels philosophically less correct than "the commit has
   data to describe itself".

In your "ephemeral tag", the workflow for a developer (D) and his
integrator (U) would look like this, I think.

 D$ until have something worth sending; do work; done
 D$ git push -s
 Enter passphrase: ...
	- "push" internally creates a pull marker that signs the commit
          object name this is pushing, among other things, and sends it
          along the primary payload
 D$ git pull-request; mail linus

 U$ git pull
 	- "pull" notices the pull marker and fetches it as well;
        - "pull" GPG validates the pull marker;
        - When preparing a merge commit message, the contents of the
          pull marker is included in .git/MERGE_MSG

The "in-commit signature" would give you 100% and your contributors 98% of
that, I think.

 D$ until have something worth sending; do work; done
        - The final round of reworking is concluded with "commit -S",
          which would GPG sign the tip commit itself
 D$ git push
	- Nothing needs to change in the protocol nor "push" itself
 D$ git pull-request; mail linus

 U$ git pull
 	- "pull" GPG validates the tip commit
	- Nothing unusual needs to happen to the resulting "merge" commit

And as a bonus, the code is already there ;-).


[Footnote]

*1* The common ancestor discovery in fetch uses as many refs as it can to
reduce the amount of data that needs to be transferred, and it is known to
hurt performance of the initial advertisement exchange when there are too
many useless refs.

*2* Do casual git users even know how to remove refs in a
remote/publishing repository?
