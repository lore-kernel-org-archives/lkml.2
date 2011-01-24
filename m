Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1AXG7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 01:59:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56623 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752046Ab1AXG7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 01:59:17 -0500
X-Authenticated: #2283611
X-Provags-ID: V01U2FsdGVkX1/aLI5JPkra4Pij3ZMqOwLFN6qBdQ2BaGGLAz/eTE
	X6RwdvbEHiHR2p
MIME-Version: 1.0
Date: Mon, 24 Jan 2011 07:59:11 +0100
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Alexander Strakh <cromlehg@gmail.com>
Cc: <mchehab@infradead.org>, <jy0922.shim@samsung.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Strakh <strakh@ispras.ru>
Subject: Re: [PATCH 1/1] Media: radio: si470x: remove double mutex lock
In-Reply-To: <1295774214-3606-1-git-send-email-strakh@ispras.ru>
References: <1295774214-3606-1-git-send-email-strakh@ispras.ru>
Message-ID: <bc5cf917273ad2d69f1a7894355c45aa@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

good catch! Thanks.

Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

On Sun, 23 Jan 2011 12:16:54 +0300, Alexander Strakh <cromlehg@gmail.com>
wrote:
> From: Alexander Strakh <cromlehg@gmail.com>
> 
> 
> 1. First mutex_lock on &radio->lock in line 441
> 2. Second in line 462
> 
> I think that mutex in line 462 is not needed. In kernel v2.6.36.3
function
> si470
> x_rds_on contains mutex_lock/mutex_unlock. Have no mutex_lock in line
441.
> In kernel v2.6.37 mutex_lock/mutex_unlock has been moved from
si470x_rds_on
> to fops_read. But old mutex_lock (line 462) forgot to remove. 
> 
>  433static ssize_t si470x_fops_read(struct file *file, char __user *buf,
>  434                size_t count, loff_t *ppos)
>  435{
> ....
>  441        mutex_lock(&radio->lock);
>  442        if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
>  443                si470x_rds_on(radio);
>  444
>  445        /* block if no new data available */
>  446        while (radio->wr_index == radio->rd_index) {
>  447                if (file->f_flags & O_NONBLOCK) {
>  448                        retval = -EWOULDBLOCK;
>  449                        goto done;
>  450                }
>  451                if (wait_event_interruptible(radio->read_queue,
>  452                        radio->wr_index != radio->rd_index) < 0) {
>  453                        retval = -EINTR;
>  454                        goto done;
>  455                }
>  456        }
>  457
>  458        /* calculate block count from byte count */
>  459        count /= 3;
>  460
>  461        /* copy RDS block out of internal buffer and to user buffer
*/
>  462        mutex_lock(&radio->lock);
> 
> Found by Linux Device Drivers Verification Project
> 
> Remove second mutex_lock from fops_read
> 
> Signed-off-by: Alexander Strakh <strakh@ispras.ru>
> ---
>  drivers/media/radio/si470x/radio-si470x-common.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c
> b/drivers/media/radio/si470x/radio-si470x-common.c
> index 60c176f..38ae6cd 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -460,7 +460,6 @@ static ssize_t si470x_fops_read(struct file *file,
> char __user *buf,
>  	count /= 3;
>  
>  	/* copy RDS block out of internal buffer and to user buffer */
> -	mutex_lock(&radio->lock);
>  	while (block_count < count) {
>  		if (radio->rd_index == radio->wr_index)
>  			break;
