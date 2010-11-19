Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab0KSTlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:41:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47990 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0KSTlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:41:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a76k6G8TY6kICSuJRY4pJQCDHQcKu8TrVqpU0HWHFQyLtfal/WdAS+Otb+xCgQjfuN
         8PhbltITmtCgffTQ2jpVJOUX6LF5MeNpjZ4j3fiAPRtns1Ou82iBtQOMcFXLfK24ne0k
         4jhAZE7mWJvTEXebCmADhsvJjvx6fFsYrAWRw=
MIME-Version: 1.0
In-Reply-To: <20101116142029.433551838@kernel.dk>
References: <20101116140900.039761100@kernel.dk>
	<20101116142029.433551838@kernel.dk>
Date: Fri, 19 Nov 2010 11:41:04 -0800
X-Google-Sender-Auth: gFRyM0h9x7qz47zDwytWfjkEjSA
Message-ID: <AANLkTingh9UxuD6xtoXmErf2v8gMr96ir5CVQhB=YdQ0@mail.gmail.com>
Subject: Re: [patch 13/28] fs: dcache scale d_unhashed
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 6:09 AM, Nick Piggin <npiggin@kernel.dk> wrote:

> @@ -1797,7 +1822,10 @@ static void d_move_locked(struct dentry
>        /*
>         * XXXX: do we really need to take target->d_lock?
>         */
> -       if (target < dentry) {
> +       if (d_ancestor(dentry, target)) {
> +               spin_lock(&dentry->d_lock);
> +               spin_lock_nested(&target->d_lock, DENTRY_D_LOCK_NESTED);
> +       } else if (d_ancestor(target, dentry) || target < dentry) {
>                spin_lock(&target->d_lock);
>                spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
>        } else {

This is the first hunk out of the series where I feel like reading the
new code makes me say "ugh".
