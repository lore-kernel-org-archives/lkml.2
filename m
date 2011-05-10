Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab1EJSzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:55:13 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:30394 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab1EJSzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:55:11 -0400
Subject: Re: [PATCH 2/2] net/dl2k: Don't reconfigure link @100Mbps when
 disabling autoneg @1Gbps
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1304986748-15809-3-git-send-email-decot@google.com>
References: <1304986748-15809-1-git-send-email-decot@google.com>
	 <1304986748-15809-3-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 10 May 2011 19:55:07 +0100
Message-ID: <1305053707.2859.57.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2011 18:55:11.0151 (UTC) FILETIME=[C9E75BF0:01CC0F43]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18126.005
X-TM-AS-Result: No--21.450000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 17:19 -0700, David Decotigny wrote:
> The initial version of the driver used to force the link to 100Mbps
> when auto-negociation was disabled on a 1Gbps link, ignoring the
> requested link speed. Instead, this change refuses to change anything
> when it is asked to configure the link speed at 1Gbps without
> auto-negociation, but acts as requested in all the other cases.
> 
> IMPORTANT: Previously, the return value from mii_set_media() was
>            ignored. This patch uses it for its own return value.
> 
> Tested: module compiling, NOT tested on real hardware.
> Signed-off-by: David Decotigny <decot@google.com>
[...]

The changes to validation look fine.  However, I noticed that there's a
call to netif_carrier_off() at the top of this function.  This means
that in the error and shortcut cases, the interface will be left
disabled!  It's an existing bug but might be made slightly worse by this
change.

Please also move the call to netif_carrier_off() down to the end, just
before the call to mii_set_media() which actually alters the link.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

