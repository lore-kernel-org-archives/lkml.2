Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1IFIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:52:17 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:58562 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab1IFIwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:52:10 -0400
Message-ID: <4E65DF36.6040507@parrot.com>
Date: Tue, 6 Sep 2011 10:52:06 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>
Subject: randconfig broken on choice
Content-Type: multipart/mixed;
	boundary="------------050900080100090908010409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------050900080100090908010409
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

I am using v3.1-rc4 and make randconfig look broken for choice.
The choice config is always the same or choice entry can have more than one entry.


After some debugging, it seems in randomize_choice_values, we don't clean
SYMBOL_VALID for choice entry.
And we don't take "sym->def[S_DEF_USER].tri" but the "default sym->cur.tri".

The following patch seems to fix the problem.


Matthieu

--------------050900080100090908010409
Content-Type: text/x-diff; name="randconfig.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="randconfig.diff"

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 59b667c..08331f8 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1045,6 +1045,10 @@ static void randomize_choice_values(struct symbol *csym)
 		else {
 			sym->def[S_DEF_USER].tri = no;
 		}
+		sym->flags |= SYMBOL_DEF_USER;
+		/* clear VALID to get value calculated */
+		sym->flags &= ~(SYMBOL_VALID);
+
 	}
 	csym->flags |= SYMBOL_DEF_USER;
 	/* clear VALID to get value calculated */

--------------050900080100090908010409--
