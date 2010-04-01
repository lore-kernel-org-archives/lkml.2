Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0DARVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:21:06 -0400
Received: from web94909.mail.in2.yahoo.com ([203.104.17.168]:31147 "HELO
	web94909.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751117Ab0DARVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:21:00 -0400
Message-ID: <488000.27888.qm@web94909.mail.in2.yahoo.com>
X-YMail-OSG: m_z64j0VM1nSElVUH4t3CEDJS4Jd157Gfcl53GHnZDGidcY
 zoi4Sj8TDPoR9qjADXyIzmxl_7HHwTvrVXKygldStb_2Yqk9EKw49wtv6oNm
 2PT24LPA9bwEcoVU8PmmubGZW.t9B6FMARsQldPLQjzY23eaFBV5VbxkVLSb
 4jcBY1Qi3AW.eA8OFTZuPwIuJaYpK6R4B5xqEqR0TrQHQZnw783w1NCS2rIi
 6t_dwtCMfRX2gC8a_Qsf0u81pCRxIg2y1_h7c7kdac81IoDwU2BY0MCGquzo
 s57.vAyTaQVFjzIWNt4xZO74-
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 1 Apr 2010 22:50:57 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 1/4/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: pavan_savoy@ti.com
> Cc: "Greg KH" <gregkh@suse.de>, "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org
> Date: Thursday, 1 April, 2010, 2:50 PM
> > +/*
> > + * function to return whether the firmware response
> was proper
> > + * in case of error don't complete so that waiting
> for proper
> > + * response times out
> > + */
> > +void validate_firmware_response(struct sk_buff *skb)
> > +{
> > +    if (unlikely(skb->data[5] !=
> 0)) {
> > +        pr_err("no
> proper response during fw download");
> > +        pr_err("data6
> %x", skb->data[5]);
> 
> In this driver you do know the device so you need to be
> using dev_ and
> passing around dev (or something that gives you dev).
> 
> > +static int kim_probe(struct platform_device *pdev)
> > +{
> > +    long status;
> > +    long proto;
> > +    long *gpios =
> pdev->dev.platform_data;
> > +
> > +    status =
> st_core_init(&kim_gdata->core_data);
> 
> I would expect any truely global data to be configured in
> the module init
> and then device specific data you want to do something like
> this
> 
>     kim_data = kzalloc(sizeof(something),
> GFP_KERNEL);
> 
>     ..
> 
>     kim_data_init(&pdev->dev,
> kim_data);
>     dev_set_drvdata(&pdev->dev,
> kim_data);
> 
> Elsewhere you can now do
> 
>     kim_data =
> dev_get_drvdata(&pdev->dev);
> 
> to get it back

There are 2 sets of data structures here (after removing the un-necessary 3rd one),
1. st_gdata - which I would want to tie to tty
2. kim_gdata - which I "would" like to tie to the pdev.

Now the problem being, I have reference of st_gdata in kim_gdata, and there are about 4 functions in the st_core where I would need the st_gdata, as in,

EXPORTED symbol st_register - because I need to add in entries as to who registered,
+long st_register(struct st_proto_s *new_proto)
+{
+    struct st_data_s    *st_gdata;
+    long err = ST_SUCCESS;
+    unsigned long flags = 0;
+
+    st_kim_ref(&st_gdata);
+    pr_info("%s(%d) ", __func__, new_proto->type);
+    if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
+        || new_proto->reg_complete_cb == NULL) {
+        pr_err("gdata/new_proto/recv or reg_complete_cb not ready");
+        return ST_ERR_FAILURE;
+    }
Also in st_unregister and st_write for similar purposes,
But I also need it in tty_open, to link it to the disc_data,

+static int st_tty_open(struct tty_struct *tty)
+{
+    int err = ST_SUCCESS;
+    struct st_data_s *st_gdata;
+    pr_info("%s ", __func__);
+
+    st_kim_ref(&st_gdata);
+    st_gdata->tty = tty;
+    tty->disc_data = st_gdata;

So, shouldn't some function like st_kim_ref be enough ?

+void st_kim_ref(struct st_data_s **core_data)
+{
+    *core_data = kim_gdata->core_data;
+}

So Now st_gdata is tied to tty, and kim_gdata being purely global, as in only 1 platform device of such kind can exist.

Suppose 2 platform devices want to exist - then who's EXPORT of st_register is considered ? 
And If bluetooth or FM wants to use this transport then, how would it tell onto which platform device it wants to attach to ?

Why should I tie kim_gdata to a pdev ?

> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
