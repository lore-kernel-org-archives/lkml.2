Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2I0RbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:31:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab2I0RbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:31:07 -0400
Date: Thu, 27 Sep 2012 13:30:57 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG_ON/panic proliferation.
Message-ID: <20120927173057.GA13142@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Myklebust, Trond" <Trond.Myklebust@netapp.com>,
	Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20120807134156.GP1996@amd.com>
 <20120927145217.GA18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com>
 <20120927153928.GB18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
 <CA+55aFx5CtDDpXTunJDtkDQWPX7sY0hYMRyekuPErC+s5yXpWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx5CtDDpXTunJDtkDQWPX7sY0hYMRyekuPErC+s5yXpWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 09:59:13AM -0700, Linus Torvalds wrote:

 > We have too many f*cking BUG_ON's in the kernel, and the fact that one
 > triggers and it has taken a month and a half without it even being
 > resolved is a problem.

This has bothered me for a while.

$ rgrep BUG_ON drivers/ | wc -l
4018
$ rgrep WARN_ON drivers/ | wc -l
2415
$ rgrep panic drivers/ | wc -l
997

$ rgrep BUG_ON fs | wc -l
2792
$ rgrep WARN_ON fs | wc -l
524
$ rgrep panic fs | wc -l
381

The number of 'raw' panic calls makes me wonder if there's perhaps
a lot of people who just don't realise that BUG_ON includes a panic() call.
If we had named it PANIC_ON it would have made it more obvious that
it has more dire consequences than WARN_ON.

Every time I read a "everything locked up while I was in X" bug,
I can't help but think it was one of these.

But even without X, sometimes these are painful.
I even had to change VM_BUG_ON to use WARN instead of BUG a while ago
in my local tree, because the panic locked up the machine before
the console had a chance to finish dumping.

What would be a good way forward though ? With tens of thousands of them in tree,
auditting them one-by-one and replacing them as we go is going to take forever.

checkpatch already has a check for new additions of BUG/BUG_ON, but the
majority of patches go into the tree unchecked, so that's not particularly helpful.

	Dave

