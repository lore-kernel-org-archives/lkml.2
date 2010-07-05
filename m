Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0GEPEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 11:04:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0GEPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 11:04:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Packet hub driver of Topcliff PCH
Date: Mon, 5 Jul 2010 17:04:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>, qi.wang@intel.com,
       joel.clark@intel.com, andrew.chih.howe.khor@intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
References: <4C204B0D.2030201@dsn.okisemi.com> <4C3187A3.10407@dsn.okisemi.com>
In-Reply-To: <4C3187A3.10407@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201007051704.01100.arnd@arndb.de>
X-Provags-ID: V02:K0:5OSUoq1hXe07jMVcGGpCYRO4yM6WUzhL47wBU1a1qGR
 Nj9ajDYiQ1S26vT8CG3uwgV2fD57clxg9YsP7Ka2P/Te8e+u+L
 QkZC9A8eH6crUeW3VBus2hJzBxDNO1vvtuYe1XqztmVZuQ6LZU
 t69W39wr29Hk3saK8lGq0yiLBVpbKZg0j8tF65xtJZWIgknJMS
 aOrt6yEf/NcFs/JHJPECQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took another look and found some more things that should be improved.
Overall, the quality of this driver has improved enourmously, and I'm
optimistic that it will be a lot easier for you in your next device
driver with all the details you have learned about the coding style.

On Monday 05 July 2010, Masayuki Ohtak wrote:
 
> +struct pch_phub_reg {
> +	u32 phub_id_reg;
> +	u32 q_pri_val_reg;
> +	u32 rc_q_maxsize_reg;
> +	u32 bri_q_maxsize_reg;
> +	u32 comp_resp_timeout_reg;
> +	u32 bus_slave_control_reg;
> +	u32 deadlock_avoid_type_reg;
> +	u32 intpin_reg_wpermit_reg0;
> +	u32 intpin_reg_wpermit_reg1;
> +	u32 intpin_reg_wpermit_reg2;
> +	u32 intpin_reg_wpermit_reg3;
> +	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
> +	u32 clkcfg_reg;
> +	void __iomem *pch_phub_base_address;
> +	void __iomem *pch_phub_extrom_base_address;
> +	int pch_phub_suspended;
> +} pch_phub_reg;

The variable you define here is in the global namespace, which it
should not be in. I'd suggest making it static and splitting the
type defintion from the variable definition to make that more obvious,
like:

struct pch_phub_reg {
	...
};

static struct pch_phub_reg pch_phub_reg;

> +static DEFINE_MUTEX(pch_phub_ioctl_mutex);
> +static DEFINE_MUTEX(pch_phub_read_mutex);
> +static DEFINE_MUTEX(pch_phub_write_mutex);

Having three mutexes here means that you have effectively no
serialization between the functions at all. The mutex only
has an effect if you use the same one in all three functions!

	Arnd
