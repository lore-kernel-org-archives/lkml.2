Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab1CWUTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:19:55 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:9967 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932896Ab1CWUTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:19:54 -0400
Message-ID: <4D8A55F7.1070802@bluewatersys.com>
Date: Thu, 24 Mar 2011 09:20:07 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au,
        adobriyan@gmail.com
Subject: Re: [PATCH 2/3] debugfs: move to new kstrtobool function
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk> <1300887554-19031-3-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1300887554-19031-3-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 02:39 AM, Jonathan Cameron wrote:
> No functional changes requires that we eat errors from
> kstrtobool.  Note *val is still only updated if a valid
> input is found.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  fs/debugfs/file.c |   19 ++++++-------------
>  1 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 89d394d..fed4485 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -429,25 +429,18 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
>  {
>  	char buf[32];
>  	int buf_size;
> +	int ret;
> +	bool bv;
>  	u32 *val = file->private_data;
>  
>  	buf_size = min(count, (sizeof(buf)-1));
>  	if (copy_from_user(buf, user_buf, buf_size))
>  		return -EFAULT;
>  
> -	switch (buf[0]) {
> -	case 'y':
> -	case 'Y':
> -	case '1':
> -		*val = 1;
> -		break;
> -	case 'n':
> -	case 'N':
> -	case '0':
> -		*val = 0;
> -		break;
> -	}
> -	
> +	ret = kstrtobool(buf, &bv);
> +	if (!ret)
> +		*val = bv;
> +
>  	return count;

Shouldn't this be:

	ret = kstrtobool(buf, &bv);
	if (ret)
		return ret;

	*val = bv;
	return count;

?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
