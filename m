Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab2ABLJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:09:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab2ABLJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:09:13 -0500
Date: Mon, 2 Jan 2012 06:09:01 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, k.skarlatos@gmail.com,
        shirishpargaonkar@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: fix bad buffer length check in coalesce_t2
Message-ID: <20120102060901.0853a6bd@tlielax.poochiereds.net>
In-Reply-To: <CAH2r5msQU=_2X799oGt1MeuejSQX2HLLW4-FgnXqg6DXHwTTZA@mail.gmail.com>
References: <1325432079-21179-1-git-send-email-jlayton@redhat.com>
	<CAH2r5msQU=_2X799oGt1MeuejSQX2HLLW4-FgnXqg6DXHwTTZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jan 2012 17:35:18 -0600
Steve French <smfrench@gmail.com> wrote:

> Any easy repro?

Not for me. It seems to depend on a variety of factors including the
infolevel used, the length of the filenames, and possibly their order
in the response.

> On Jan 1, 2012 9:34 AM, "Jeff Layton" <jlayton@redhat.com> wrote:
> 
> > The current check looks to see if the RFC1002 length is larger than
> > CIFSMaxBufSize, and fails if it is. The buffer is actually larger than
> > that by MAX_CIFS_HDR_SIZE.
> >
> > This bug has been around for a long time, but the fact that we used to
> > cap the clients MaxBufferSize at the same level as the server tended
> > to paper over it. Commit c974befa changed that however and caused this
> > bug to bite in more cases.
> >
> > Reported-and-Tested-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/cifs/connect.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8cd4b52..27c4f25 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct
> > smb_hdr *pTargetSMB)
> >        byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
> >        byte_count += total_in_buf2;
> >        /* don't allow buffer to overflow */
> > -       if (byte_count > CIFSMaxBufSize)
> > +       if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)
> >                return -ENOBUFS;
> >        pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);
> >
> > --
> > 1.7.7.4
> >
> >


-- 
Jeff Layton <jlayton@redhat.com>
