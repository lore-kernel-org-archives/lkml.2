Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1JaXJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:09:14 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:49785 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab1JaXJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=YgiZ5fLA6syMEPs7aV4YU7y/pBMYjmQy
	8qKgaNhI7av0C6/11wFSVXjF7S+QOX178MStl/TPmSMvuybLGeDHOj8tKrTAnNJf
	iPP+y5GQ7pUECHOBueJoW9htT8Tik04W0It9S1muvjUc/JwXzu9LiXpK5kFcELzS
	IuZLqUhfBe8=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, git@vger.kernel.org,
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
 <4EAF1F40.3030907@zytor.com>
 <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com>
 <4EAF2245.90308@zytor.com>
 <CA+55aFzedaAzzWfzhqVf8y8ZW0jeb56hZwdV3UodSp8Q_Qhc2A@mail.gmail.com>
 <7vvcr4ojvp.fsf@alter.siamese.dyndns.org>
Date: Mon, 31 Oct 2011 16:09:09 -0700
In-Reply-To: <7vvcr4ojvp.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Mon, 31 Oct 2011 15:51:06 -0700")
Message-ID: <7vlis0oj1m.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 57B975AA-0415-11E1-8ED5-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> ...
> As I already said, I do not think notes is a good match as a tool to do
> this.
>
>> matters is that "git push" and "git pull" would JustWork(tm), and
>> check the signature if one exists, without having to cut-and-paste
>> data that simply shouldn't be visible to the user.
>>
>> I abhor the interface Ingo suggested, for example....
>
> Some cut-and-paste (or piping the e-mail to a command) would be necessary
> evil, though, as you would have GPG keys from more than one trusted person
> in your keyring, and when you are responding to a pull-request from person
> A, finding a valid commit signed by person B should not be a success, but
> at least should raise a warning.

So here is a quick hack that does not involve cut-and-paste (it depends on
the signed-commit topic in 'next').

 $ git pull --require-signature

would trigger signature verification and stops you after fetching but
before merging.

 git-pull.sh |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/git-pull.sh b/git-pull.sh
index 9868a0b..f3b4c93 100755
--- a/git-pull.sh
+++ b/git-pull.sh
@@ -39,7 +39,7 @@ test -z "$(git ls-files -u)" || die_conflict
 test -f "$GIT_DIR/MERGE_HEAD" && die_merge
 
 strategy_args= diffstat= no_commit= squash= no_ff= ff_only=
-log_arg= verbosity= progress= recurse_submodules=
+log_arg= verbosity= progress= recurse_submodules= must_be_signed=
 merge_args=
 curr_branch=$(git symbolic-ref -q HEAD)
 curr_branch_short="${curr_branch#refs/heads/}"
@@ -60,6 +60,8 @@ do
 		diffstat=--no-stat ;;
 	--stat|--summary)
 		diffstat=--stat ;;
+	--require-signature)
+		must_be_signed=yes ;;
 	--log|--no-log)
 		log_arg=$1 ;;
 	--no-c|--no-co|--no-com|--no-comm|--no-commi|--no-commit)
@@ -208,6 +210,27 @@ orig_head=$(git rev-parse -q --verify HEAD)
 git fetch $verbosity $progress $dry_run $recurse_submodules --update-head-ok "$@" || exit 1
 test -z "$dry_run" || exit 0
 
+if test -n "$must_be_signed"
+then
+	signature=$(git show -s --format='%G?' FETCH_HEAD)
+	case "$signature" in
+	G)
+		case "$verbosity" in
+		*' '-v*)
+			git show -s --show-signature FETCH_HEAD ;;
+		esac
+		;;
+	B)
+		echo >&2 "Bad signature on the tip commit"
+		exit 1
+		;;
+	*)
+		echo >&2 "Tip commit must be signed"
+		exit 1
+		;;
+	fi
+fi
+
 curr_head=$(git rev-parse -q --verify HEAD)
 if test -n "$orig_head" && test "$curr_head" != "$orig_head"
 then
