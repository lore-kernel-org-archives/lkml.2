Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab2CFD1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:27:44 -0500
Received: from ozlabs.org ([203.10.76.45]:47569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab2CFD1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:27:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Santosh Jodh <Santosh.Jodh@citrix.com>,
        "konrad.wilk\@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy\@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "jbarnes\@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "jbeulich\@novell.com" <jbeulich@novell.com>,
        "joe.jin\@oracle.com" <joe.jin@oracle.com>,
        "lersek\@redhat.com" <lersek@redhat.com>,
        "weiyi.huang\@gmail.com" <weiyi.huang@gmail.com>,
        "dgdegra\@tycho.nsa.gov" <dgdegra@tycho.nsa.gov>,
        David Vrabel <david.vrabel@citrix.com>,
        "paul.gortmaker\@windriver.com" <paul.gortmaker@windriver.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "waldi\@debian.org" <waldi@debian.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel\@lists.xen.org" <xen-devel@lists.xen.org>
Cc: Santosh Jodh <Santosh.Jodh@citrix.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH 0001/001] xen: multi page ring support for block devices
In-Reply-To: <7914B38A4445B34AA16EB9F1352942F1010A1FA12364@SJCPMAILBOX01.citrite.net>
References: <1330701099-18281-1-git-send-email-santoshprasadnayak@gmail.com> <7914B38A4445B34AA16EB9F1352942F1010A1FA12364@SJCPMAILBOX01.citrite.net>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 06 Mar 2012 13:12:49 +1030
Message-ID: <87ty22xxee.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012 13:49:07 -0800, Santosh Jodh <Santosh.Jodh@citrix.com> wrote:
> +/* Order of maximum shared ring size advertised to the front end. */
> +int xen_blkif_max_ring_order = XENBUS_MAX_RING_ORDER;
> +
> +#define BLK_RING_SIZE(_order) __CONST_RING_SIZE(blkif, PAGE_SIZE << (_order))
> +
> +static int set_max_ring_order(const char *buf, struct kernel_param *kp)
> +{
> +       int err;
> +       unsigned long order;
> +
> +       err = kstrtol(buf, 0, &order);
> +       if (err ||
> +           order < 0 ||
> +           order > XENBUS_MAX_RING_ORDER)
> +               return -EINVAL;

Hmm, order can't be < 0, since it's unsigned.  So did you mean
kstrtoull?

And I think returning err is cleaner (it's -EINVAL for malformed
strings, -ERANGE for ones too big).

> +       if (xen_blkif_reqs < BLK_RING_SIZE(order))
> +               printk(KERN_WARNING "WARNING: "
> +                      "I/O request space (%d reqs) < ring order %ld, "
> +                      "consider increasing %s.reqs to >= %ld.",
> +                      xen_blkif_reqs, order, KBUILD_MODNAME,
> +                      roundup_pow_of_two(BLK_RING_SIZE(order)));

This message doesn't mention the module namr or parameter name
anywhere.  Think of the poor sysadmins!

Thanks,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
