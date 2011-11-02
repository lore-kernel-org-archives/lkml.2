Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1KBKxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:53:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58754 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143Ab1KBKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:53:35 -0400
X-Sasl-enc: LYd+91UGSjdk4U8KllJikXu+i0xoqCcp49C4rK4em5Gz 1320231214
Message-ID: <4EB12122.7010803@drmicha.warpmail.net>
Date: Wed, 02 Nov 2011 11:53:22 +0100
From: Michael J Gruber <git@drmicha.warpmail.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com> <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com> <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano venit, vidit, dixit 01.11.2011 20:47:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
>> But what would be nice is that "git pull" would fetch the tag (based on
>> name) *automatically*, and not actually create a tag in my repository at
>> all. Instead, if would use the tag to check the signature, and - if we
>> do this right - also use the tag contents to populate the merge commit
>> message.
>>
>> In other words, no actual tag would ever be left around as a turd, it
>> would simply be used as an automatic communication channel between the
>> "git push -s" of the submitter and my subsequent "git pull". Neither
>> side would have to do anything special, and the tag would never show
>> up in any relevant tree (it could even be in a totally separate
>> namespace like "refs/pullmarker/<branchname>" or something).
> 
> While I like the "an ephemeral tag is used only for hop-to-hop
> communication to carry information to be recorded in the resulting
> history" approach, I see a few downsides.
> 
>  * The ephemeral tag needs to stay somewhere under refs/ hierarchy of the
>    lieutenant's tree until you pick it up, even if they are out of the way
>    in refs/pullmarker/$branchname. The next time the same lieutenant makes
>    a pull request, either it will be overwritten or multiple versions of
>    them refs/pullmarker/$branchname/$serial need to be kept.

If we are interested in commit sigs, the easiest tag-based approach is
to name the sig carrying tag by the commit's sha1. Just like the sig is
tied (in)to a commit in Junio's approach, it would be indexed by it. We
can do that now:

git config --global alias.sign '!f() { c=$(git rev-parse "$1") || exit;
shift; git tag -s $@ sigs/$c $c; }; f'

But a different place rather than refs/tags/sigs/<sha1> will be more
appropriate, so that we don't pollute the tag namespace. (Yes, this is
similar to storing them in notes.) tags have a message etc.

With an appropriate refspec, these sigs can be pushed out automatically
(by the lieutenant).

pull-request as in next will list the expected <sha1> at tip.

git pull needs to learn to (fetch and) use refs/<whatever>/<sha1> to
verify that the tip is signed.

git log --show-signature can do the same tricks as with in-commit sigs.

Some things to decide in this approach:
- Should git-pull (pull sigs and) verify by default?
- Should we worry about overwriting existings sigs? We have union-merge
for notes already, and that would be appropriate for sigs. (Yes, our
tags code does verify multiple concatenated sigs.)

The advantage of tags is that they can be added without rewriting the
commit, of course.

Michael
