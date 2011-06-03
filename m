Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1FCSfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:35:00 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:10978
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790Ab1FCSe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:34:58 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE9294B.3040501@freescale.com>
Date: Fri, 3 Jun 2011 13:34:51 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
References: <1307119552-15573-1-git-send-email-timur@freescale.com>	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>	<4DE92675.6080908@freescale.com> <BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
In-Reply-To: <BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:

> If mm is shared, data can or will change under you.

Ah, that's a good point.  The only side-effect I can see of that is that it will
copy the string incorrectly, but it won't overwrite memory.

Would it be better if I did this:

	str = kzalloc(max, GFP_KERNEL);
	if (!str)
		return ERR_PTR(-ENOMEM);

	if (copy_from_user(str, ustr, max - 1)) {
		kfree(str);
		return ERR_PTR(-EFAULT);
	}

	return krealloc(str, strlen(str) + 1, GFP_KERNEL);

Maybe the krealloc() is overkill.

>> > How else is it supposed to know how much to allocate
>> > without using strlen first?
> I don't know.
> What I know is that your function doesn't guarantee NUL-termination.

That's a bug.  The copy_from_user() should look like this:

	if (copy_from_user(str, ustr, len - 1)) {

-- 
Timur Tabi
Linux kernel developer at Freescale

