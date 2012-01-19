Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2ASOVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:21:43 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61975 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2ASOVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:21:39 -0500
X-Nat-Received: from [202.181.97.72]:53724 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1326982891.7448
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [GIT] More security subsystem fixes
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.00.1201191631040.31730@tundra.namei.org>
	<201201190620.q0J6KMvA047997@www262.sakura.ne.jp>
In-Reply-To: <201201190620.q0J6KMvA047997@www262.sakura.ne.jp>
Message-Id: <201201192321.AIB12409.LOJQOOMtVSFFFH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 19 Jan 2012 23:21:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 19012012 #6589912, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> James Morris wrote:
> >       MPILIB: Add a missing ENOMEM check
> Maybe one more (shown below) with some random comments.

Looked a bit more.



In lib/mpi/mpih-div.c:

mpi_limb_t
mpihelp_divrem(mpi_ptr_t qp, mpi_size_t qextra_limbs,
               mpi_ptr_t np, mpi_size_t nsize, mpi_ptr_t dp, mpi_size_t dsize)
{
        mpi_limb_t most_significant_q_limb = 0;

        switch (dsize) {
        case 0:
                /* We are asked to divide by zero, so go ahead and do it!  (To make
                   the compiler not remove this statement, return the value.)  */
                return 1 / dsize;

What's this? Division by 0 in the kernel is no good.



In lib/mpi/mpicoder.c:

MPI do_encode_md(const void *sha_buffer, unsigned nbits)
{
(...snipped...)
        n = 0;
        frame[n++] = 0;
        frame[n++] = 1;         /* block type */
        i = nframe - SHA1_DIGEST_LENGTH - asnlen - 3;

        if (i <= 1) {
                pr_info("MPI: message digest encoding failed\n");
                kfree(frame);
                return a;
        }

        memset(frame + n, 0xff, i);
        n += i;
        frame[n++] = 0;
        memcpy(frame + n, &asn, asnlen);
        n += asnlen;
        memcpy(frame + n, sha_buffer, SHA1_DIGEST_LENGTH);
        n += SHA1_DIGEST_LENGTH;

        i = nframe;
        fr_pt = frame;

        if (n != nframe) {

What's this? i = nframe - SHA1_DIGEST_LENGTH - asnlen - 3; equals
nframe = i + SHA1_DIGEST_LENGTH + asnlen + 3; and this should be always true.
Also, i = nframe; seems to make no sense because i is no longer used.

                printk
                    ("MPI: message digest encoding failed, frame length is wrong\n");
                kfree(frame);
                return a;
        }

        a = mpi_alloc((nframe + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB);

Missing a != NULL check.

        mpi_set_buffer(a, frame, nframe, 0);
        kfree(frame);

        return a;
}



In lib/mpi/mpi-pow.c:

int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
{
(...snipped...)
        if (!msize)
                msize = 1 / msize;      /* provoke a signal */
(...snipped...)
}

Division by 0.



In lib/mpi/mpi-div.c:

int mpi_tdiv_q_2exp(MPI w, MPI u, unsigned count)
{
(...snipped...)
        usize = u->nlimbs;
        limb_cnt = count / BITS_PER_MPI_LIMB;
        wsize = usize - limb_cnt;
        if (limb_cnt >= usize)
                w->nlimbs = 0;
        else {
                mpi_ptr_t wp;
                mpi_ptr_t up;

                if (RESIZE_IF_NEEDED(w, wsize) < 0)
                        return -ENOMEM;
                wp = w->d;
                up = u->d;

                count %= BITS_PER_MPI_LIMB;
                if (count) {
                        mpihelp_rshift(wp, up + limb_cnt, wsize, count);
                        wsize -= !wp[wsize - 1];
(...snipped...)
}

Is wsize > 0 guaranteed?



Fixes (if any) will be needed to RHEL6's 2.6.32-220.2.1.el6 kernel as well.
