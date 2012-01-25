Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2AYM0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:26:33 -0500
Received: from mga05.intel.com ([192.55.52.89]:8003 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753043Ab2AYM0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:26:31 -0500
MIME-Version: 1.0
In-Reply-To: <201201192321.AIB12409.LOJQOOMtVSFFFH@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.00.1201191631040.31730@tundra.namei.org>
	<201201190620.q0J6KMvA047997@www262.sakura.ne.jp>
	<201201192321.AIB12409.LOJQOOMtVSFFFH@I-love.SAKURA.ne.jp>
Date: Wed, 25 Jan 2012 14:26:29 +0200
Message-ID: <CALLzPKaspvd2RkDpccEGNyziPRGRhSmEsOYYapysFSY+EEC4WQ@mail.gmail.com>
Subject: Re: [GIT] More security subsystem fixes
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 4:21 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Tetsuo Handa wrote:
>> James Morris wrote:
>> >       MPILIB: Add a missing ENOMEM check
>> Maybe one more (shown below) with some random comments.
>
> Looked a bit more.
>
>
>
> In lib/mpi/mpih-div.c:
>
> mpi_limb_t
> mpihelp_divrem(mpi_ptr_t qp, mpi_size_t qextra_limbs,
>               mpi_ptr_t np, mpi_size_t nsize, mpi_ptr_t dp, mpi_size_t dsize)
> {
>        mpi_limb_t most_significant_q_limb = 0;
>
>        switch (dsize) {
>        case 0:
>                /* We are asked to divide by zero, so go ahead and do it!  (To make
>                   the compiler not remove this statement, return the value.)  */
>                return 1 / dsize;
>
> What's this? Division by 0 in the kernel is no good.
>
>
>
> In lib/mpi/mpicoder.c:
>
> MPI do_encode_md(const void *sha_buffer, unsigned nbits)
> {
> (...snipped...)
>        n = 0;
>        frame[n++] = 0;
>        frame[n++] = 1;         /* block type */
>        i = nframe - SHA1_DIGEST_LENGTH - asnlen - 3;
>
>        if (i <= 1) {
>                pr_info("MPI: message digest encoding failed\n");
>                kfree(frame);
>                return a;
>        }
>
>        memset(frame + n, 0xff, i);
>        n += i;
>        frame[n++] = 0;
>        memcpy(frame + n, &asn, asnlen);
>        n += asnlen;
>        memcpy(frame + n, sha_buffer, SHA1_DIGEST_LENGTH);
>        n += SHA1_DIGEST_LENGTH;
>
>        i = nframe;
>        fr_pt = frame;
>
>        if (n != nframe) {
>
> What's this? i = nframe - SHA1_DIGEST_LENGTH - asnlen - 3; equals
> nframe = i + SHA1_DIGEST_LENGTH + asnlen + 3; and this should be always true.

In fact n always equals to nframe, and this check is always false...


> Also, i = nframe; seems to make no sense because i is no longer used.
>
>                printk
>                    ("MPI: message digest encoding failed, frame length is wrong\n");
>                kfree(frame);
>                return a;
>        }
>
>        a = mpi_alloc((nframe + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB);
>
> Missing a != NULL check.
>
>        mpi_set_buffer(a, frame, nframe, 0);
>        kfree(frame);
>
>        return a;
> }
>
>
>
> In lib/mpi/mpi-pow.c:
>
> int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
> {
> (...snipped...)
>        if (!msize)
>                msize = 1 / msize;      /* provoke a signal */
> (...snipped...)
> }
>
> Division by 0.
>
>
>
> In lib/mpi/mpi-div.c:
>
> int mpi_tdiv_q_2exp(MPI w, MPI u, unsigned count)
> {
> (...snipped...)
>        usize = u->nlimbs;
>        limb_cnt = count / BITS_PER_MPI_LIMB;
>        wsize = usize - limb_cnt;
>        if (limb_cnt >= usize)
>                w->nlimbs = 0;
>        else {
>                mpi_ptr_t wp;
>                mpi_ptr_t up;
>
>                if (RESIZE_IF_NEEDED(w, wsize) < 0)
>                        return -ENOMEM;
>                wp = w->d;
>                up = u->d;
>
>                count %= BITS_PER_MPI_LIMB;
>                if (count) {
>                        mpihelp_rshift(wp, up + limb_cnt, wsize, count);
>                        wsize -= !wp[wsize - 1];
> (...snipped...)
> }
>
> Is wsize > 0 guaranteed?
>
Should be, because of the check:
        if (limb_cnt >= usize)
                w->nlimbs = 0;
       else...


>
>
> Fixes (if any) will be needed to RHEL6's 2.6.32-220.2.1.el6 kernel as well.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
