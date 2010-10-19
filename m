Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0JSNNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:13:44 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:34181 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab0JSNNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:13:42 -0400
X-Authority-Analysis: v=1.1 cv=pepdxKapwHuwCZNFD5uob2wvham6E+RljB0uXw08FdQ= c=1 sm=0 a=1112M1-s6nIA:10 a=kj9zAlcOel0A:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=rOUgymgbAAAA:8 a=hGzw-44bAAAA:8 a=O5b7UbTgrNqYk1jxoJUA:9 a=Ri0lYAn9Vdh6d7xZ4yQ-p6upNskA:4 a=CjuIK1q_8ugA:10 a=dowx1zmaLagA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Tue, 19 Oct 2010 09:13:39 -0400
From: Jeff Layton <jlayton@samba.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
Message-ID: <20101019091339.38e45faa@tlielax.poochiereds.net>
In-Reply-To: <20101019162120.76e03b4b.sfr@canb.auug.org.au>
References: <20100924135531.96e5ac72.sfr@canb.auug.org.au>
	<20101019162120.76e03b4b.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 16:21:20 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Steve,
> 
> On Fri, 24 Sep 2010 13:55:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the irqflags tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > fs/cifs/sess.c: In function 'CIFS_SessSetup':
> > fs/cifs/sess.c:595: warning: unused variable 'blob_len'
> > 
> > Introduced by commit 15f6bdfb9914b0c41848f874719911ba053be931 ("cifs
> > NTLMv2/NTLMSSP ntlmv2 within ntlmssp autentication code").
> > CONFIG_CIFS_UPCALL is not set in this build.
> 
> I am still getting this ...
> 

Yep. Looks clearly broken. blob_len is also declared twice in that
function which is just plain wrong. What probably makes the most sense
is to make it a u16 and get rid of the second declaration lower in the
function. But, there's another semi-related problem here too...

blob_len gets assigned the return value of build_ntlmssp_auth_blob.
That function however doesn't have any mechanism to pass back an
error, even though it calls setup_ntlmv2_rsp and that function can
return one.

The whole house of cards needs a bit of rework I think...

Shirish, since you're already doing work in this area, can you fix that
too?

Thanks,
-- 
Jeff Layton <jlayton@samba.org>
