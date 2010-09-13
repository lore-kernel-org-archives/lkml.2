Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0IMWZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 18:25:07 -0400
Received: from smtp104.sbc.mail.ne1.yahoo.com ([98.138.84.215]:41591 "HELO
	smtp104.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752382Ab0IMWZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 18:25:04 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: QFt.yIEVM1l9h_T_2q_QkxUwQAygu_ts7MKn.W3YFhUvOU3
 K8Z87BvbCddbpaYOZ2n4YCNgnnX9s0FX5uGTKXnugdDH0ObuNKJSsVcWeVd.
 s0ghoS3Wjyrd3IX.0XI0manAV8nWbeFZRZwhdfIu_EiqaNz3L.kyyg0FSW1F
 rrxyVBUcNk1Dy4tYlOEzFqYs2o7GS4k2nntR6WuxTN7W5Tt6vWK8K.aaokGb
 ZtUsiHSVFT2E3JdRJCaFrZRKkcu7Sm1n8AgJJ7SY5es8tGhTygmUHBcGOHxi
 9U2riZvO4H.SCqPx7_d4maEzUUvxJQ2uTwuBZC5lrN7MHvXzWWi2GRNPw
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and
	crc32-intel offload
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>
In-Reply-To: <1284410406.8171.63.camel@haakon2.linux-iscsi.org>
References: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
	 <4C8DED17.6080801@suse.de>
	 <1284407432.8171.41.camel@haakon2.linux-iscsi.org>
	 <4C8E8AF5.5080205@cs.wisc.edu>
	 <1284410406.8171.63.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 15:20:55 -0700
Message-Id: <1284416455.8171.89.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 13:40 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2010-09-13 at 15:35 -0500, Mike Christie wrote:
> > On 09/13/2010 02:50 PM, Nicholas A. Bellinger wrote:
> > >> IE the in-kernel crc32c routines apparently weren't able to
> > >> calculate the checksum in an endianness-independent manner.
> > >> So a CRC calculated on a BE machine would fail to be validated by a
> > >> LE machine and vice versa.
> > >>
> > >> Has this been fixed / verified?
> > >>
> > >
> > >> From taking a look at crypto/crc32c.c it still appears AFAICT to not be
> > > big endian safe.  I was planning to test this patch on some powerpc/ppc
> > > hardware with v2.6.36-rc4 in the next days, but it looks like
> > > lio-core-2.6.git will need a seperate crypto/crc32c.c patch to function
> > > properly on big endian arches.
> > >
> > 
> > There was this bug that was fixed a couple years ago:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ef19454bd437b2ba14c9cda1de85debd9f383484
> > since then I think we have not had problems.
> 
> Hi Mike,
> 
> Thanks for the pointer on this, I will give it a shot on powerpc and see
> what happens.
> 
> FYI, I was under the assumption that for BIG_ENDIAN that crc32c() still
> needed an bitshift for the returned value.  This is what we had been
> doing with our old internal do_crc() code here:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/lio-target/iscsi_crc.c;hb=83559072b27eb8cd92abb9a3fc9be85018c5db06#l138
> 
> AFAICT there is still nothing that makes crypto/crc32c.c big endian
> safe, unless I am overlooking something obvious..?
> 

Hi Mike and Hannes,

So after a quick test using Open-iSCSI 32-bit x86 VM w/ v2.6.27 and
LIO-Target 64-bit powerpc w/v2.6.36-rc3 with this libcrypto patch I do
not see any HeaderDigest or DataDigest failures using the exiting
slicing by 1x crypto/crc32c.c code on 64-bit BIG_ENDIAN.  While I am at
it I will also try OpenSuse 11.2 and RHEL6 B2 x86_64 VMs for good
measure.

So the appropiate endian conversion does occur in chksum_final() and
__chksum_finup() code.  My apologies for the earier confusion.

Thanks again,

--nab


