Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2ASGUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:20:32 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63650 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2ASGUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:20:30 -0500
X-Nat-Received: from [202.181.97.72]:58065 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1326954022.27699
Message-Id: <201201190620.q0J6KMvA047997@www262.sakura.ne.jp>
Subject: Re: [GIT] More security subsystem fixes 
From: from-linux-security-module@i-love.sakura.ne.jp
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 19 Jan 2012 15:20:22 +0900
References: <alpine.LRH.2.00.1201191631040.31730@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1201191631040.31730@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 19012012 #6581730, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
>       MPILIB: Add a missing ENOMEM check
Maybe one more (shown below) with some random comments.



        for (i = a->nlimbs - 1; i >= 0; i--) {
                alimb = a->d[i];
#if BYTES_PER_MPI_LIMB == 4
                *p++ = alimb >> 24;
                *p++ = alimb >> 16;
                *p++ = alimb >> 8;
                *p++ = alimb;
#elif BYTES_PER_MPI_LIMB == 8
                *p++ = alimb >> 56;
                *p++ = alimb >> 48;
                *p++ = alimb >> 40;
                *p++ = alimb >> 32;
                *p++ = alimb >> 24;
                *p++ = alimb >> 16;
                *p++ = alimb >> 8;
                *p++ = alimb;
#else
#error please implement for this limb size.
#endif

Are such large bitshift guaranteed to work?



MPI do_encode_md(const void *sha_buffer, unsigned nbits)
{
(...snipped...)
        a = mpi_alloc((nframe + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB);
	// Missing a != NULL check here.
        mpi_set_buffer(a, frame, nframe, 0);
        kfree(frame);
(...snipped...)
}

Is (nframe + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB * sizeof(mpi_limb_t)
guaranteed not to overflow? Is nlimbs guaranteed to be not 0?

MPI mpi_alloc(unsigned nlimbs)
{
	mpi_alloc_limb_space(nlimbs)
	{
		mpi_ptr_t mpi_alloc_limb_space(unsigned nlimbs)
		{
		        size_t len = nlimbs * sizeof(mpi_limb_t);
		
		        return kmalloc(len, GFP_KERNEL);
		}
	}
}

There are several kmalloc(nlimbs * sizeof(mpi_limb_t)) calls.
Are they guaranteed not to overflow?

int mpi_resize(MPI a, unsigned nlimbs)
{
        void *p;

        if (nlimbs <= a->alloced)
                return 0;       /* no need to do it */

        if (a->d) {
		// Can use krealloc()?
                p = kmalloc(nlimbs * sizeof(mpi_limb_t), GFP_KERNEL);
                if (!p)
                        return -ENOMEM;
                memcpy(p, a->d, a->alloced * sizeof(mpi_limb_t));
                kfree(a->d);
                a->d = p;
        } else {
                a->d = kzalloc(nlimbs * sizeof(mpi_limb_t), GFP_KERNEL);
                if (!a->d)
                        return -ENOMEM;
        }
        a->alloced = nlimbs;
        return 0;
}

Roughly browsing, it seems to me that this module assumes that kmalloc()
returns NULL if requested size was 0. It is OK for userspace, but I think we
should introduce and use a version of kmalloc() that returns NULL if requested
size was 0 (so that we can catch 0 byte allocation unless overflow).
