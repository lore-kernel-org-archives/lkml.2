Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2ACWqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:46:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48073 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab2ACWqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <1325432079-21179-1-git-send-email-jlayton@redhat.com>
References: <1325432079-21179-1-git-send-email-jlayton@redhat.com>
Date: Tue, 3 Jan 2012 16:46:15 -0600
Message-ID: <CADT32eK53tJakiLm5VVE9cY3R6mLkA2PYWxwNG17ybK=u6NYNg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix bad buffer length check in coalesce_t2
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: smfrench@gmail.com, linux-kernel@vger.kernel.org, k.skarlatos@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 1, 2012 at 9:34 AM, Jeff Layton <jlayton@redhat.com> wrote:
> The current check looks to see if the RFC1002 length is larger than
> CIFSMaxBufSize, and fails if it is. The buffer is actually larger than
> that by MAX_CIFS_HDR_SIZE.
>
> This bug has been around for a long time, but the fact that we used to
> cap the clients MaxBufferSize at the same level as the server tended
> to paper over it. Commit c974befa changed that however and caused this
> bug to bite in more cases.
>
> Reported-and-Tested-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8cd4b52..27c4f25 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
>        byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
>        byte_count += total_in_buf2;
>        /* don't allow buffer to overflow */
> -       if (byte_count > CIFSMaxBufSize)
> +       if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)
>                return -ENOBUFS;
>        pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);
>
> --
> 1.7.7.4
>

This looks correct.  But the way Windows XP server responds to request
 trans2/find_first2/info level is different than how Windows 2003 Server
and Windows 2008 Server respond.

So a related concern would be, for a response from Windows XP server,
this check in function check2ndT2 does not make sense.
 if (total_data_size > CIFSMaxBufSize) {

It is possible to have large number of entries in a directory such that the
response to a  ls  command can exceed CIFSMaxBufSize.
