Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0GRLBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 07:01:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45438 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0GRLBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 07:01:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 18 Jul 2010 13:00:50 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 5/4 RFC] firewire: cdev: add PHY pinging
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.506ae60f1ea3a97a@s5r6.in-berlin.de>
Message-ID: <tkrat.6c75a797bbb6b2f7@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
 <tkrat.506ae60f1ea3a97a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Jul, Stefan Richter wrote:
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -1105,6 +1105,10 @@ static int at_context_queue_packet(struc
>  	} else {
>  		last = &d[0];
>  		z = 2;
> +
> +		if (packet->header_length == 8 &&
> +		    is_ping_packet(packet->header))
> +			last->control |= cpu_to_le16(DESCRIPTOR_PING);
>  	}
>  
>  	last->control |= cpu_to_le16(DESCRIPTOR_OUTPUT_LAST |

Here is a better implementation of the card driver's part.  It moves the
ping packet test out of an else branch that is taken for all no-payload
packets into a switch block that is only reached in case of PHY packets.

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1068,6 +1068,9 @@ static int at_context_queue_packet(struc
 		header[1] = cpu_to_le32(packet->header[0]);
 		header[2] = cpu_to_le32(packet->header[1]);
 		d[0].req_count = cpu_to_le16(12);
+
+		if (is_ping_packet(packet->header))
+			d[0].control |= cpu_to_le16(DESCRIPTOR_PING);
 		break;
 
 	case 4:

-- 
Stefan Richter
-=====-==-=- -=== =--=-
http://arcgraph.de/sr/

