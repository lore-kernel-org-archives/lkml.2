Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab2AKCjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 21:39:04 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:51118 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933596Ab2AKCjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 21:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=Y0AmOM
	m7uYm4HW8FY3IG+2q6XD6MFPQU7kTzsyCXiNTCLSVm3wi5rMAV80x4kghf2xBDxF
	pvyGSxFKkVfWGnMpHbxspGCCgFGXoURJnCoo+qfrWxHTze2v+FH4IeSjzhK1rg/g
	UfEZm00GY1qzjfFQEMZFSk+YtwiyINYPrk51E=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Git Mailing List <git@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] use generic pci_iomap on all architectures
References: <20120105145836.GA2751@redhat.com>
 <20120106083141.9c14a8d2d09539c6a6c0db75@canb.auug.org.au>
 <20120106083916.9588034bde22a6803e327aa9@canb.auug.org.au>
 <20120106084701.8f704542754db826deda318a@canb.auug.org.au>
 <CA+55aFwXj2ELrTDSgFfSC2Usz99-24uFSznAP34feJiCttwayQ@mail.gmail.com>
Date: Tue, 10 Jan 2012 18:38:58 -0800
In-Reply-To: <CA+55aFwXj2ELrTDSgFfSC2Usz99-24uFSznAP34feJiCttwayQ@mail.gmail.com> (Linus
 Torvalds's message of "Tue, 10 Jan 2012 17:51:07 -0800")
Message-ID: <7vipkj7ykd.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 6A7D5DE4-3BFD-11E1-8274-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Jan 5, 2012 at 1:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> On Fri, 6 Jan 2012 08:39:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> So why does you pull request refer to "commit
>>> 805a6af8dba5dfdd35ec35dc52ec0122400b2610", I wonder?  Is that just what
>>> "git request-pull" produced?
>>
>> I see, "git request-pull" just puts in whatever you specify on the
>> command line rather than the merge-base ...
>
> .. and that is a fairly silly misfeature, since it makes the "since
> commit xyz" largely meaningless.
>
> I suspect we really should make "git request-pull" show the merge
> base(s) as the "since commit", because that way the output of git
> request-pull is "stable", and doesn't depend on what particular random
> state you've synced up to since.
>
> Junio, I think the patch would be as simple as the attached - totally
> untested - one-liner? Comments?

I think it makes sense.

We use whatever garbage the user gave us (e.g. "origin/linus" which may
have been updated since the topic forked and be made irrelevant) only to
figure out where the history forked, and once we find that out we
consistently use the fork-point which has some meaning.

The parameter to "git shortlog" that appears later should also be updated
to match this, by the way, even though that should not affect the outcome
in any way.

I am however not sure what would happen when there are more than one merge
bases. I guess those who throw pull requests are not supposed to be doing
merges in reverse direction, so it should not matter ;-)

 git-request-pull.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/git-request-pull.sh b/git-request-pull.sh
index d7ba117..38b68bb 100755
--- a/git-request-pull.sh
+++ b/git-request-pull.sh
@@ -96,7 +96,7 @@ git show -s --format='The following changes since commit %H:
   %s (%ci)
 
 are available in the git repository at:
-' $baserev &&
+' $merge_base &&
 echo "  $url${ref+ $ref}" &&
 git show -s --format='
 for you to fetch changes up to %H:
@@ -124,7 +124,7 @@ then
 	echo "----------------------------------------------------------------"
 fi &&
 
-git shortlog ^$baserev $headrev &&
+git shortlog $merge_base..$headrev &&
 git diff -M --stat --summary $patch $merge_base..$headrev || status=1
 
 if test -z "$ref"
