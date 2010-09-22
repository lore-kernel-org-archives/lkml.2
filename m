Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab0IVVmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:42:50 -0400
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:39390 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751596Ab0IVVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:42:49 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 9JyfBSQVM1nC3Hbyk1c0Pu4vAl7fX87jZPSiDLyp2Idrtv1
 ndCeXtlqlOYFMA8nkEnl7S.cyPs.FZJ.Bnm0K2aFq0z_XFP4R5YvIlz_5NmB
 zSCcOotcLo_mYhGGUcZdtx13hL2WzOLURUEGmzi5KN.11UKOyC48DeuZj18Y
 yxd9h2WhoGgDT9uR6th2_LSf_Bmf_Ou9CCuT5uiQTumBpPxSS0KjTxNLvWPh
 CaPCehp5gdUGYLuwv2kj9N.lDUJSJz5AmuL6WZobYthlZ8UGCqYUmaWOLCTq
 JflKD6T3TMtBw5dW3ebciRbiXGuXbboworWDEN433wPux6dw_oN0uL4VsEaZ
 17DNZpfegnsskOeZow3ks9oUS5VqeEhQtrafCpf9cd0eo._QaptF3Dk8wk6r
 2_fVnXL4Ww2bEOLMNTQ--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction
	using libcrypto crc32c-intel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>
In-Reply-To: <20100922211808.GJ11157@obsidianresearch.com>
References: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org>
	 <4C9A698B.90806@linux.intel.com>
	 <1285187901.1849.85.camel@haakon2.linux-iscsi.org>
	 <20100922205943.GI11157@obsidianresearch.com>
	 <1285189241.1849.112.camel@haakon2.linux-iscsi.org>
	 <20100922211808.GJ11157@obsidianresearch.com>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 14:38:31 -0700
Message-Id: <1285191511.1849.126.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 15:18 -0600, Jason Gunthorpe wrote:
> [cc list chopped]
> 
> On Wed, Sep 22, 2010 at 02:00:41PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2010-09-22 at 14:59 -0600, Jason Gunthorpe wrote:
> > > On Wed, Sep 22, 2010 at 01:38:21PM -0700, Nicholas A. Bellinger wrote:
> > > 
> > > > Indeed, this would clean up the explict RX/TX CRC32C case quite a
> > > > bit..  Unfortuately I am too busy with other items atm to cook up
> > > > this patch, but I would be happy to test it if someone wants to take
> > > > it.  ;)
> > > 
> > > Do you even need to do anything at all? crc32c is provided by
> > > crc32c-intel at a higher priority already, so it should be used if it
> > > is available..
> > 
> > I believe with the current libcrypto code that consumers are still
> > required to explictly ask for crc32c-intel offload.
> 
> Really? It all looks OK to me.. What does your /proc/crypto say on a
> system with crc32c-intel support?

After a fresh boot /proc/crypto looks like:

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 0

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

Once I start up the LIO-Target stack and some iSCSI Initiators login
and request crc32c-intel using crypto_alloc_hash() using a method similar
to what this patch for Softiwarp does, the following appears in at the top
of /proc/crypto:

name         : crc32c
driver       : crc32c-intel
module       : crc32c_intel
priority     : 200
refcnt       : 5
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

So I think the main bit here is the ability to request crc32c-intel.ko first,
and then fall back to crc32c.ko when the former is not available on CONFIG_X86.

Best,

--nab

