Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1FUOUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:20:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab1FUOUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:20:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
Date: Tue, 21 Jun 2011 16:20:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "davinci-linux-open-source" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106211620.02065.arnd@arndb.de>
X-Provags-ID: V02:K0:wYxFCEim8TrjQzpWomBzE5968ENtsmoOwOy2QN299Zi
 ilW1Ync3UIrwPaPK4odeOcda5pWWaWGH+HY7a0kbGt3pT7Z3+z
 aT9xGsaH8e9XTVRLeC/uwnZJl0Uss2G2N3iNonkchDKI5pOzWC
 US6bpJH4JLekQHYCGUM19eUjargIhjEhOB9HKeqye5lBqVRmTD
 7pb9lEfckLBhI6p11F5/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Tuesday 21 June 2011, Ohad Ben-Cohen wrote:

> This patch set adds a generic AMP/IPC framework which makes it possible to
> control (power on, boot, power off) and communicate (simply send and receive
> messages) with those remote processors.

This looks really nice overall, but I don't currently have time for a
more in-depth review. My feeling is that you are definitely on the right
track here, and the plans you list as TODO to continue are all good.

One point I noticed is the use of debugfs, which you should probably
replace at some point with a stable API, e.g. your own debugfs-like
file system, but there is no hurry to do that now.

> The gory part of remoteproc is the firmware handling. We tried to come up
> with a simple binary format that will require minimum kernel code to handle,
> but at the same time be generic enough in the hopes that it would prove
> useful to others as well. We're not at all hang onto the binary format
> we picked: if there's any technical reason to change it to support other
> platforms, please let us know. We do realize that a single binary firmware
> structure might eventually not work for everyone. it did prove useful for
> us though; we adopted both the OMAP and Davinci platforms (and their
> completely different remote processor devices) to this simple binary
> structure, so we don't have to duplicate the firmware handling code.

Regarding the firmware, I think it would be nice to have the option
to stick the firmware blob into the flattened device tree as a bininclude,
so you can build systems using the external processors without special
user space support.

The binary format looks reasonable, but if you need anything more complex,
you should probably go straight for ELF files ;-)

The structures you use like

+struct fw_section {
+       u32 type;
+       u64 da;
+       u32 len;
+       char content[0];
+} __packed;

Unfortunately require __packed. It would be better to sort the members
differently so that each member is naturally aligned in order to
avoid the need for padding or __packed attributes, like:

struct fw_section {
       u32 type;
       u32 len;
       u64 da;
       char content[0];
};

	Arnd
