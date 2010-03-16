Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937958Ab0CPQSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:18:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56606 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937992Ab0CPQSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xsehMQoaNSojXi6MFsTsXhXlNPA/KFPxbEcbyXqI9yYU6A2/PNnurEXqWeenDya7KK
         9wcwIQihl9wgKwD1/XpHJkXlgRQB0S+n9eIaK3K+0Q71L40+pcH2dOo2y9dT61H/cgb0
         pvSA+4eu2G5l87Wrn/I8fAeTIUUjBLEkYnYUQ=
MIME-Version: 1.0
In-Reply-To: <4B9F86E9.2030702@gmail.com>
References: <4B9F86E9.2030702@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Mar 2010 09:18:31 -0700
Message-ID: <43e72e891003160918x3b7e3c9asf4fc8a9db35ccd8a@mail.gmail.com>
Subject: Re: regd: sleeping in atomic
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/16 Jiri Slaby <jirislaby@gmail.com>:
> Hi,
>
> Stanse found an atomic error in reg_copy_regd:
>
> static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
>                         const struct ieee80211_regdomain *src_regd)
> {
>        struct ieee80211_regdomain *regd;
>        int size_of_regd = 0;
>        unsigned int i;
>
>        size_of_regd = sizeof(struct ieee80211_regdomain) +
>          ((src_regd->n_reg_rules + 1) * sizeof(struct ieee80211_reg_rule));
>
>        regd = kzalloc(size_of_regd, GFP_KERNEL);       <---- here
>
> Called from:
>
> static void reg_regdb_search(struct work_struct *work)
> {
>        spin_lock(&reg_regdb_search_lock);
>        while (!list_empty(&reg_regdb_search_list)) {
> ...
>                for (i=0; i<reg_regdb_size; i++) {
>                        curdom = reg_regdb[i];
>
>                        if (!memcmp(request->alpha2, curdom->alpha2, 2)) {
>                                r = reg_copy_regd(&regdom, curdom);
> ...
>        spin_unlock(&reg_regdb_search_lock);
> }
>
> Whole error temporarily available at:
> http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=34-rc&id=578
>
> It is introduced by 3b377ea9d4efc94dc52fe41b4dfdb463635ab298.
>
> Do you plan to extend it somehow or may the spinlock be converted to mutex?

I don't think you can convert this directly to a mutex. The spin_lock
in question (&reg_regdb_search_lock) gets also used by
reg_regdb_query() which in turn gets called by call_crda(). There is
one iteration of call_crda() which happens during module
initialization and from what I gather I don't think the kernel is
happy when you mutex_lock on load routines, please correct my foggy
memory if I am mistaken. So during module load we directly end up
hitting the spin_lock in question, prior to the workqueue using it.

Not sure yet how to address this, any ideas John?

> If not how much may size_of_regd be -- can we safely switch to GFP_ATOMIC?

The count is up to 117 right now. It should be around the number of
countries of the world today, tomorrow even different countries could
have different regulatory domains. This happened with Japan a while
back when they required manufacturers to apply certification rules
depending on the year the product went out.. and this changed many
times in that country. But another reason why this number may also
increase in any given country without regards to silly legislation is
for experimenters who want to enhance the use of the spectrum in
certain areas and would use sha1sums instead of alpha2s for the
regdomains. But we're light years away from that happening.

  Luis
