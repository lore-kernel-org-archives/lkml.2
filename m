Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1IEU3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:29:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1IEU2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:28:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Mon, 05 Sep 2011 22:27:37 +0200
Message-ID: <2596745.EN1Uy6S4kH@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E652A36.1070101@zytor.com>
References: <4E582577.2060805@zytor.com> <CAMe9rOoDjV8UC++X50FtNvgAac23rWu1EEju-3aUE939u8Lv1w@mail.gmail.com> <4E652A36.1070101@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kzfsCKoWrO9pItjyKV6D2tXIZnHOH7QPXEHI3u4pynQ
 vaLV79iDkXOKQ+3V96zJfWjH6evWd8vlL6XihYsr3rTI8aFW84
 SWvTHtvLjM0HMAQxp65fQCjFXW5NjWHAoadDMetQ5c5QgArgHT
 BbvSnDUXyY7XphTJlDGuC/tuXbvxGL+GVArA57eQn0+Lr/iVJH
 cmqK6JpxkXmLXlBFZzbSF9TcI/4qsv3741frrle2yo7F7LSAyd
 sI5/eepoqPWa03dJvdM/Hqm4sNLua8WDS8aTvDDY9IrbXak+lV
 UmUPJzY9cs81kc31yM2/tbkPTmuaq2m7bwKNK/upzGLfJRVy5P
 jVxONIOoSvSaQhe5GFfM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 September 2011 12:59:50 H. Peter Anvin wrote:
> On 09/05/2011 12:54 PM, H.J. Lu wrote:
> > 
> > Since  readv/writev/preadv/pwritev have const struct iovec *iov, I
> > have to copy the whole array.  compat_sys seems more efficient.
> > 
> 
> compat_sys for these do exactly what we want, right?

Quoting from compat_rw_copy_check_uvector():

        if (nr_segs > fast_segs) {
                ret = -ENOMEM;
                iov = kmalloc(nr_segs*sizeof(struct iovec), GFP_KERNEL);
                if (iov == NULL)
                        goto out;
        }
        *ret_pointer = iov;

        /*
         * Single unix specification:
         * We should -EINVAL if an element length is not >= 0 and fitting an
         * ssize_t.
         *
         * In Linux, the total length is limited to MAX_RW_COUNT, there is
         * no overflow possibility.
         */
        tot_len = 0;
        ret = -EINVAL;
        for (seg = 0; seg < nr_segs; seg++) {
                compat_uptr_t buf;
                compat_ssize_t len;

                if (__get_user(len, &uvector->iov_len) ||
                   __get_user(buf, &uvector->iov_base)) {
                        ret = -EFAULT;
                        goto out;
                }
                if (len < 0)    /* size_t not fitting in compat_ssize_t .. */
                        goto out;
                if (!access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
                        ret = -EFAULT;
                        goto out;
                }
                if (len > MAX_RW_COUNT - tot_len)
                        len = MAX_RW_COUNT - tot_len;
                tot_len += len;
                iov->iov_base = compat_ptr(buf);
                iov->iov_len = (compat_size_t) len;
                uvector++;
                iov++;
        }


compared to native rw_copy_check_uvector():

        if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
                ret = -EFAULT;
                goto out;
        }

        /*
         * According to the Single Unix Specification we should return EINVAL
         * if an element length is < 0 when cast to ssize_t or if the
         * total length would overflow the ssize_t return value of the
         * system call.
         *
         * Linux caps all read/write calls to MAX_RW_COUNT, and avoids the
         * overflow case.
         */
        ret = 0;
        for (seg = 0; seg < nr_segs; seg++) {
                void __user *buf = iov[seg].iov_base;
                ssize_t len = (ssize_t)iov[seg].iov_len;

                /* see if we we're about to use an invalid len or if
                 * it's about to overflow ssize_t */
                if (len < 0) {
                        ret = -EINVAL;
                        goto out;
                }
                if (unlikely(!access_ok(vrfy_dir(type), buf, len))) {
                        ret = -EFAULT;
                        goto out;
                }
                if (len > MAX_RW_COUNT - ret) {
                        len = MAX_RW_COUNT - ret;
                        iov[seg].iov_len = len;
                }
                ret += len;
        }

This is better than I thought for the compat version. The only overhead
is in reading the array in word chunks as opposed to a single memcpu for
the native case. This should barely be noticeably within the other stuff
done in the same function. So you are both right, the compat case is good.

I was assuming that this would do something worse, like an extra copy
of the data back to userspace.

	Arnd
