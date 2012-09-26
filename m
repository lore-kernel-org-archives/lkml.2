Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2IZHtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:49:09 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:38193 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab2IZHtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:49:08 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Date: Wed, 26 Sep 2012 09:48:12 +0200
Subject: RE: [PATCH 1/3] virtio_console:Merge struct buffer_token into
 struct port_buffer
Thread-Topic: [PATCH 1/3] virtio_console:Merge struct buffer_token into
 struct port_buffer
Thread-Index: Ac2bkOOebLasAkCqSHq7T1MYcCtjKAAI0u2Q
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BD8365F7@EXDCVYMBSTM005.EQ1STM.local>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
 <1348580837-10919-2-git-send-email-sjur.brandeland@stericsson.com>
 <50626C11.9040708@hitachi.com>
In-Reply-To: <50626C11.9040708@hitachi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8Q7nFWd030238

> > This merge reduces code size by unifying the approach for
> > sending scatter-lists and regular buffers. Any type of
> > write operation (splice, write, put_chars) will now allocate
> > a port_buffer and send_buf() and free_buf() can always be used.
> 
> Thanks!
> This looks much nicer and simpler. I just have some comments below.

OK, good to hear that you agree to this kind of change. I'll do a respin
of this patch fixing the issues you have pointed out.

> >  static void free_buf(struct port_buffer *buf)
> >  {
> > +	int i;
> > +
> >  	kfree(buf->buf);
> 
> this should be done only when !buf->sgpages, or (see below)

Agree, I'll put this statement in an else branch to the if-statement below.

> 
> > +
> > +	if (buf->sgpages)
> > +		for (i = 0; i < buf->sgpages; i++) {
> > +			struct page *page = sg_page(&buf->sg[i]);
> > +			if (!page)
> > +				break;
> > +			put_page(page);
> > +		}
> > +
> >  	kfree(buf);
> >  }
> >
> > -static struct port_buffer *alloc_buf(size_t buf_size)
> > +static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
> > +				     int nrbufs)
> >  {
> >  	struct port_buffer *buf;
> > +	size_t alloc_size;
> >
> > -	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
> > +	/* Allocate buffer and the scatter list */
> > +	alloc_size = sizeof(*buf) + sizeof(struct scatterlist) * nrbufs;
> 
> This allocates one redundant sg entry when nrbuf > 0,
> but I think it is OK. (just a comment)

I did this on purpose for the sake of simplicity, but I can
change this to something like:
	 alloc_size = sizeof(*buf) + sizeof(buf->sg) * max(nrbufs - 1, 1);


> > +	buf = kmalloc(alloc_size, GFP_ATOMIC);
> 
> This should be kzalloc(), or buf->buf and others are not initialized,
> which will cause unexpected kfree bug at kfree(buf->buf) in free_buf.

Agree, kzalloc() is better in this case. 

> >  	if (!buf)
> >  		goto fail;
> > -	buf->buf = kzalloc(buf_size, GFP_KERNEL);
> > +
> > +	buf->sgpages = nrbufs;
> > +	if (nrbufs > 0)
> > +		return buf;
> > +
> > +	buf->buf = kmalloc(buf_size, GFP_ATOMIC);
> 
> You can also use kzalloc here as previous code does.
> But if the reason why using kzalloc comes from the security,
> I think kmalloc is enough here, since the host can access
> all the guest pages anyway.

With this new patch alloc_buf() is used both for both RX and TX.
The out_vq did previously use malloc(). But I have preserved
the legacy behavior for the in_vq by calling memset() in function
fill_queue().

Thanks,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
