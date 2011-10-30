Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab1J3PgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 11:36:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146Ab1J3PgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 11:36:24 -0400
Message-ID: <4EAD6EF3.50109@canonical.com>
Date: Sun, 30 Oct 2011 11:36:19 -0400
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] Input: ALPS - Remove assumptions about packet size
References: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com> <1319663681-11244-5-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1319663681-11244-5-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 05:14 PM, Seth Forshee wrote:
> In preparation for version 4 protocol support, which has 8-byte
> data packets, remove all hard-coded assumptions about packet size
> and use psmouse->pktsize instead.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/input/mouse/alps.c |   27 ++++++++++++++++++---------
>  1 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 572cb21..14d1f64 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -315,7 +315,7 @@ static void alps_flush_packet(unsigned long data)
>  
>  	serio_pause_rx(psmouse->ps2dev.serio);
>  
> -	if (psmouse->pktcnt == 6) {
> +	if (psmouse->pktcnt == psmouse->pktsize) {
>  
>  		/*
>  		 * We did not any more data in reasonable amount of time.
> @@ -365,15 +365,15 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
>  		return PSMOUSE_BAD_DATA;
>  	}
>  
> -	/* Bytes 2 - 6 should have 0 in the highest bit */
> -	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= 6 &&
> +	/* Bytes 2 - pktsize should have 0 in the highest bit */
> +	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= psmouse->pktsize &&
>  	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80)) {
>  		dbg("refusing packet[%i] = %x\n",
>  		    psmouse->pktcnt - 1, psmouse->packet[psmouse->pktcnt - 1]);
>  		return PSMOUSE_BAD_DATA;
>  	}
>  
> -	if (psmouse->pktcnt == 6) {
> +	if (psmouse->pktcnt == psmouse->pktsize) {
>  		alps_process_packet(psmouse);
>  		return PSMOUSE_FULL_PACKET;
>  	}
> @@ -531,8 +531,13 @@ static int alps_tap_mode(struct psmouse *psmouse, int enable)
>  static int alps_poll(struct psmouse *psmouse)
>  {
>  	struct alps_data *priv = psmouse->private;
> -	unsigned char buf[6];
> +	unsigned char *buf;
>  	bool poll_failed;
> +	int ret = -1;
> +
> +	buf = kmalloc(psmouse->pktsize, GFP_KERNEL);
> +	if (!buf)
> +		return -1;

Can we preallocate a buffer somewhere instead of allocating every time
we enter the function? If we know the maximum packet size we could
allocate on the stack instead.

-- Chase
