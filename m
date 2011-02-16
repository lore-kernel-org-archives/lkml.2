Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1BPX5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:57:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758Ab1BPX5D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:57:03 -0500
MIME-Version: 1.0
In-Reply-To: <20110216232816.GH29600@atj.dyndns.org>
References: <20110216181153.5b8f81d5@katamari> <20110216232816.GH29600@atj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 15:56:10 -0800
Message-ID: <AANLkTikuMNjk=nBvaARXJ0LBp_8OS+-iMv20t-rf34ph@mail.gmail.com>
Subject: Re: [Patch v2] block: revert block_dev read-only check
To: Tejun Heo <tj@kernel.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 3:28 PM, Tejun Heo <tj@kernel.org> wrote:
>
> The commit was part of effort to enforce the ro flag.  It at least
> makes sure that a device can't be opened RW if marked RO.  loop and dm
> showed some problems but fixing the in-kernel part isn't difficult
> (fixes pending).

Well, if the thing breaks things, then it needs to be reverted, or
those fixes need to not be "pending".

However:

> IIUC, the problematic part is dm userland, which reportedly opens
> member devices RW even when building a RO device.  The problem is when
> a user is trying to build RO dm device from RO member devices.  dm
> userland tries to open the member devices RW, which block layer
> rejects now thus failing dm assembly.

.. this makes me all the more suspicious. Sounds unfixable in a single
release (or even a few years). So it smells like we should (a) do the
revert and (b) add a warning for the case where somebody opens a
device RW where the low-level device itself is RO.

That said, if the user has permission to open the device RW (and the
normal device node permission checks have obviously always done that
check), I do think it's perfectly ok to do that. And if the user never
writes to it, then the fact that the device isn't writable is
irrelevant.

So maybe even the warning is worthless. But we can try it and see how
annoying it would be.

                      Linus
