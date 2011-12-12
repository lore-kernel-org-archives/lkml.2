Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1LLLOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:14:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1LLLOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:14:30 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
Date: Mon, 12 Dec 2011 12:15:56 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
References: <20111210104341.592561407@chello.nl> <1323684748.16764.62.camel@twins> <CACVXFVNUGTu-gF=jkNg37cmc1wKFvycYojs96VS8eowyLsJ8fg@mail.gmail.com>
In-Reply-To: <CACVXFVNUGTu-gF=jkNg37cmc1wKFvycYojs96VS8eowyLsJ8fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112121215.56645.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. Dezember 2011, 11:32:58 schrieb Ming Lei:
> On Mon, Dec 12, 2011 at 6:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I don't know the driver model, and I don't plan to start learning it
> > now. But if what you said is possible its broken and no memory barriers
> > will fix it.
> 
> IMO, you don't need to learn it, and my example is very simple and common
> kref usage in device drivers, :-)
> 
> Could we only focus on it and see what is problem? and why won't memory
> barrier fix it?

You don't have a CPU ordering problem. If CPU A can do a kfree() you need to
make sure CPU B doesn't get a pointer to that object. Basically your race is:

CPU A							CPU B

p = a;
								p = a;
p->counter--;
if (!p->counter) kfree(p);
a = NULL;
								p->counter++;

This is not an ordering problem. You have a real critical section here.
It doesn't matter when CPU B sees the decrement.
You must make sure there are no pointers to objects you might free
if you intend to use the pointers without locks.

	Regards
		Oliver
