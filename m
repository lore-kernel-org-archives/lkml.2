Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1KEDzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 23:55:48 -0400
Received: from 99-108-226-0.lightspeed.iplsin.sbcglobal.net ([99.108.226.0]:33856
	"EHLO peff.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1KEDzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 23:55:45 -0400
Date: Fri, 4 Nov 2011 23:55:42 -0400
From: Jeff King <peff@peff.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Junio C Hamano <junio@pobox.com>, git@vger.kernel.org,
        Shawn Pearce <spearce@spearce.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <20111105035542.GA1974@sigill.intra.peff.net>
References: <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <CA+55aFzstE-+NzfSAWMEokB7-rYsZOcZe9Ez-LxPNOKnciJ3UQ@mail.gmail.com>
 <7vlirvbq47.fsf@alter.siamese.dyndns.org>
 <7v39e3bn1n.fsf@alter.siamese.dyndns.org>
 <CA+55aFzKPPqwGOe5Ov0FHF1DHbKmNhm=ePvcaY5uqR7cwFhQGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzKPPqwGOe5Ov0FHF1DHbKmNhm=ePvcaY5uqR7cwFhQGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 04:10:59PM -0700, Linus Torvalds wrote:

> I'm pretty sure people have already done "git merge v3.1" kind of
> things using local tags (where no peeling of FETCH_HEAD has been
> done). See
> 
>     git log --merges --grep 'Merge.*v[23]\.[0-9]'
> 
> for a ton of examples of this (and there's something odd going on: we
> have "Merge commit .." and "Merge tag ..", and I suspect the latter is
> people editing it to be correct by hand, but I dunno).

It looks like fmt-merge-msg looks in FETCH_HEAD to see if each line is
marked as "branch" or "tag". So I get "Merge tag ..." with:

  git pull . tag v1.0

but I get "Merge commit ..." with:

  git merge v1.0

When "git merge" is run, it actually creates a fake FETCH_HEAD in memory
and feeds it to fmt-merge-msg. But that process doesn't seem to bother
looking at tags. I think we just need this:

---
diff --git a/builtin/merge.c b/builtin/merge.c
index dffd5ec..6a44b6d 100644
--- a/builtin/merge.c
+++ b/builtin/merge.c
@@ -439,10 +439,15 @@ static void merge_name(const char *remote, struct strbuf *msg)
 		if (!prefixcmp(found_ref, "refs/heads/")) {
 			strbuf_addf(msg, "%s\t\tbranch '%s' of .\n",
 				    sha1_to_hex(branch_head), remote);
 			goto cleanup;
 		}
+		if (!prefixcmp(found_ref, "refs/tags/")) {
+			strbuf_addf(msg, "%s\t\ttag '%s' of .\n",
+				    sha1_to_hex(branch_head), remote);
+			goto cleanup;
+		}
 		if (!prefixcmp(found_ref, "refs/remotes/")) {
 			strbuf_addf(msg, "%s\t\tremote-tracking branch '%s' of .\n",
 				    sha1_to_hex(branch_head), remote);
 			goto cleanup;
 		}

where the result of merge_name is just fed to fmt-merge-msg eventually.

-Peff
