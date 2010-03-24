Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0CXWAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:00:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0CXWAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:00:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Wed, 24 Mar 2010 22:59:57 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de> <adavdclz8sc.fsf@roland-alpha.cisco.com>
In-Reply-To: <adavdclz8sc.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003242259.58535.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19cuuh6RqfKyIVA1EZHC04+Swdj5wlMZy5iLQn
 kvdD2zTu0jyQZm9goovJrgcvhi/EzMNEnheeqHvRIV5/nIj/T0
 sNgivad7X4dAXkKVpZgag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010 22:53:07 Roland Dreier wrote:
> Interesting work.  For the drivers/infiniband part, it seems maybe all
> these drivers should be using no_llseek instead of default_llseek?  (or
> is it better style to use nonseekable_open()?)  Certainly as far as I
> can tell, nothing in drivers/infiniband pays any attention to f_pos.

no_llseek makes it clear that you don't want the default_llseek semantics,
while nonseekable_open also prevents pread/pwrite. Ideally, I'd just
use both.

There is a small chance that a random user space application actually tries
to seek on the device (e.g. SEEK_END) and expects a zero return value,
so when in doubt, I converted everything to default_llseek instead of
no_llseek, just so I can be sure I don't change the semantics.

> Also, is there a reason why you add "#include <linux/smp_lock.h>" to all
> the files where you also do ".llseek  = default_llseek"?

The last patch in the series moves the default_llseek and default_ioctl
function into the same loadable module that contains the BKL itself.
Moving the declarations into the respective header seemed appropriate,
but it could also stay in a VFS header if people prefer that.

> In any case I can at least take care of the llseek stuff for 2.6.35.

Ok, thanks!

	Arnd
