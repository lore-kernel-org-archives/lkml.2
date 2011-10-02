Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1JBMLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 08:11:39 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53366 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304Ab1JBMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 08:11:32 -0400
Subject: Re: [RFCv4 PATCH 2/6] ivtv: only start streaming in poll() if
 polling for input.
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Date: Sun, 02 Oct 2011 08:13:11 -0400
In-Reply-To: <32566dbc40ed36da1ef324afd8a09813c1bc080c.1317281827.git.hans.verkuil@cisco.com>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
	 <32566dbc40ed36da1ef324afd8a09813c1bc080c.1317281827.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317557592.2328.0.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-10-01_08:2011-09-30,2011-10-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1110010295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 09:44 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

FWIW:

Acked-by: Andy Walls <awalls@md.metrocast.net>

-Andy


> ---
>  drivers/media/video/ivtv/ivtv-fileops.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
> index 38f0522..a931ecf 100644
> --- a/drivers/media/video/ivtv/ivtv-fileops.c
> +++ b/drivers/media/video/ivtv/ivtv-fileops.c
> @@ -744,8 +744,9 @@ unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
>  	return res;
>  }
>  
> -unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
> +unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table *wait)
>  {
> +	unsigned long req_events = poll_requested_events(wait);
>  	struct ivtv_open_id *id = fh2id(filp->private_data);
>  	struct ivtv *itv = id->itv;
>  	struct ivtv_stream *s = &itv->streams[id->type];
> @@ -753,7 +754,8 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
>  	unsigned res = 0;
>  
>  	/* Start a capture if there is none */
> -	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
> +	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags) &&
> +			(req_events & (POLLIN | POLLRDNORM))) {
>  		int rc;
>  
>  		mutex_lock(&itv->serialize_lock);


