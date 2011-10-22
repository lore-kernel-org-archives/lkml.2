Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1JVRY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 13:24:56 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:59548 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab1JVRYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 13:24:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/lkml
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE mappings
In-Reply-To: Linus Torvalds's message of  Saturday, 22 October 2011 06:38:33 +0300 <CA+55aFy3ALC34AyrsHi9yjBgRMwg9G5w2PhDfr_JVti1M8GbNQ@mail.gmail.com>
References: <20111021213916.914462C0A5@topped-with-meat.com>
	<CA+55aFy3ALC34AyrsHi9yjBgRMwg9G5w2PhDfr_JVti1M8GbNQ@mail.gmail.com>
Emacs: you'll understand when you're older, dear.
Message-Id: <20111022172450.0BCCE2C0A9@topped-with-meat.com>
Date: Sat, 22 Oct 2011 10:24:50 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=27hm96M904wA:10
		a=kj9zAlcOel0A:10 a=Qcz7jFQlpixEKVtGc28A:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I'm not against this, but I'm wondering what triggers the need for it?
> 
> It does make the security checks more complicated, since now
> mprotect() suddenly has to care about mmap_min_addr. So I don't think
> it's a security enhancement ("attempt to ensure robustness").
> 
> But if there is some actual use-case that is shown to be helped,
> please document that n the explanations for the changeset.

It's exactly the case that I did mention: an application's own attempt to
ensure robustness by doing a PROT_NONE mmap of the [0,0x10000) region.  An
application cannot presume that this region is already precluded from being
used by any non-MAP_FIXED mmap across all systems and configurations, so
it's defensive coding to explicitly block it off with a PROT_NONE mapping.

Since we know mmap_min_addr-type constraints might exist, we start at 0 and
move up a page as long as mmap fails.  That works fine to cover e.g. the
[0x1000,0x10000) region when mmap_min_addr is set to 4096, as is common.
However, under SELinux these harmless attempts are diagnosed as MMAP_ZERO
avc denials, which percolate up to the user as scare warnings that the
application was prevented from doing something dangerous and possibly
malicious, when that's not the case at all.


Thanks,
Roland
