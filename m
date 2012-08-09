Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2HIJMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:12:53 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48452 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2HIJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:12:51 -0400
X-AuditID: b753bd60-90ac1ba0000047ca-01-50237f108a2c
X-AuditID: b753bd60-90ac1ba0000047ca-01-50237f108a2c
Message-ID: <50237F07.2020907@hitachi.com>
Date: Thu, 09 Aug 2012 18:12:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 1/6] virtio/console: Add splice_write support
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp> <20120724023707.6600.69536.stgit@ltc189.sdl.hitachi.co.jp> <20120809090015.GG3280@amit.redhat.com>
In-Reply-To: <20120809090015.GG3280@amit.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/09 18:00), Amit Shah wrote:
> On (Tue) 24 Jul 2012 [11:37:07], Yoshihiro YUNOMAE wrote:
>> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
>> Enable to use splice_write from pipe to virtio-console port.
>> This steals pages from pipe and directly send it to host.
>>
>> Note that this may accelerate only the guest to host path.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Amit Shah <amit.shah@redhat.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
> 
>> +/* Faster zero-copy write by splicing */
>> +static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>> +				      struct file *filp, loff_t *ppos,
>> +				      size_t len, unsigned int flags)
>> +{
>> +	struct port *port = filp->private_data;
>> +	struct sg_list sgl;
>> +	ssize_t ret;
>> +	struct splice_desc sd = {
>> +		.total_len = len,
>> +		.flags = flags,
>> +		.pos = *ppos,
>> +		.u.data = &sgl,
>> +	};
>> +
>> +	sgl.n = 0;
>> +	sgl.len = 0;
>> +	sgl.sg = kmalloc(sizeof(struct scatterlist) * MAX_SPLICE_PAGES,
>> +			 GFP_ATOMIC);
> 
> Do you expect this function to be called from interrupt context?

No, not at all. Oops, that should be GFP_KERNEL...

Thank you for pointing it out.

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


