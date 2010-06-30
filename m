Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0F3Qs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:48:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830Ab0F3Qs1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:48:27 -0400
MIME-Version: 1.0
In-Reply-To: <87mxuc91r2.fsf@linux.vnet.ibm.com>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com>
	<alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
	<20100608004102.GQ31073@ZenIV.linux.org.uk>
	<87pqzrexon.fsf@linux.vnet.ibm.com>
	<871vbwe6lp.fsf@linux.vnet.ibm.com>
	<AANLkTiksmwITS6aCuXXZGR916OTEBm9VQ1MSzzEt8F7S@mail.gmail.com>
	<AANLkTikyqHtazndL_zBux7Zk0qZSJuNEvitHj8wkuSWW@mail.gmail.com>
	<87mxuc91r2.fsf@linux.vnet.ibm.com>
Date: Wed, 30 Jun 2010 09:48:15 -0700
Message-ID: <AANLkTim0YCgTr_9GRo31kgwojIjeAyR895cyvbkFMmDg@mail.gmail.com>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 
	2.6.35-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 4:52 AM, Aneesh Kumar K. V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
>
> You are correct. we cannot drop the rename lock in between. I also found
> another issue in that we are using dentry->d_name.name directly. That
> would imply we need to hold the rename_lock even during the
> client_walk.

Yes.

> How about the patch below ?. I updated the patch to hold
> rename_lock during multiple path walk. Also the rename path is updated
> to hold the lock during p9_client_rename operations.

I'm not finding any obvious problems with this, and you're right that
you also need to hold the rename write-lock even for regular renames
(not just cross-directory ones) in order to protect the name itself.
So those two patches together seem to be ok at a quick glance.

That said, I do wonder if you wouldn't be better off copying the name
components in order to then drop the lock earlier. That way you'd only
need to hold the lock while walking the dentries, and could possibly
release it during the actual walk (unless you need the names to be
stable, but I don't think you can rely on that anyway, since other
clients might be doing renames concurrently.. I don't know)

                       Linus
