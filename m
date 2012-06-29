Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2F2UDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:03:21 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39769 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2F2UDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:03:20 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Refactor shortname parsing
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	<87r4syrl4y.fsf@devron.myhome.or.jp>
	<1340997235.9826.7.camel@iscandar.digidescorp.com>
Date: Sat, 30 Jun 2012 05:03:16 +0900
In-Reply-To: <1340997235.9826.7.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Fri, 29 Jun 2012 14:13:55 -0500")
Message-ID: <87bok1sx6j.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> On Sat, 2012-06-30 at 04:08 +0900, OGAWA Hirofumi wrote: 
>> "Steven J. Magnani" <steve@digidescorp.com> writes:
>> 
>> > Nearly identical shortname parsing is performed in fat_search_long()
>> > and __fat_readdir(). Extract this code into a function that may be
>> > called by both.
>> 
>> What is the difference, and why changes was needed?
>
> The only difference I could see was in the "dot_hidden" functionality.  
> fat_search_long() never does it; __fat_readdir() does it only when the
> 'dotsOK' option is active.
>
> The changes are not 'needed'; they are purely to simplify future
> maintenance of the code.

Ah, I misread your email. I thought you made the nearly identical
parser. So, this patch is no logic change, right?

OK, looks like good though. If we added to check vfat and run, it might
be more readable. E.g. the following?

> +	if (dot_hidden && (de->attr & ATTR_HIDDEN)) {
> +		*ptname++ = '.';
> +		dotoffset = 1;
> +	}
> +
> +	memcpy(work, de->name, sizeof(work));
> +	/* see namei.c, msdos_format_name */
> +	if (work[0] == 0x05)
> +		work[0] = 0xE5;
> +
> +	/* Filename */
> +	for (i = 0, j = 0; i < 8;) {
> +		c = work[i];
> +		if (!c)
> +			break;
> +		chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
> +					&uni_name[j++], opt_shortname,
> +					de->lcase & CASE_LOWER_BASE);
> +		if (chl <= 1) {
> +			ptname[i++] = fat_tolower(!nocase, c);

			if (is_vfat)
				ptname[i++] = fat_tolower(!nocase, c);

> +			if (c != ' ') {
> +				name_len = i;
> +				uni_len  = j;
> +			}
> +		} else {
> +			uni_len = j;
> +			for (chi = 0; chi < chl && i < 8; chi++) {
> +				ptname[i] = work[i];

				if (is_vfat)
					ptname[i] = work[i];

> +				i++;
> +				name_len = i;
> +			}
> +		}
> +	}
> +
> +	i = name_len;
> +	j = uni_len;
> +	fat_short2uni(nls_disk, ".", 1, &uni_name[j++]);
> +	ptname[i++] = '.';
	if (is_vfat)
		ptname[i++] = '.';
> +
> +	/* Extension */
> +	for (k = 8; k < MSDOS_NAME;) {
> +		c = work[k];
> +		if (!c)
> +			break;
> +		chl = fat_shortname2uni(nls_disk, &work[k], MSDOS_NAME - k,
> +					&uni_name[j++], opt_shortname,
> +					de->lcase & CASE_LOWER_EXT);
> +		if (chl <= 1) {
> +			k++;
> +			ptname[i++] = fat_tolower(!nocase, c);

  		        if (is_vat)
				ptname[i++] = fat_tolower(!nocase, c);

> +			if (c != ' ') {
> +				name_len = i;
> +				uni_len  = j;
> +			}
> +		} else {
> +			uni_len = j;
> +			for (chi = 0; chi < chl && k < MSDOS_NAME; chi++) {
> +				ptname[i++] = work[k++];
> +				name_len = i;
> +			}
> +		}
> +	}
> +
> +	if (name_len > 0) {
> +		name_len += dotoffset;
> +
> +		if (sbi->options.isvfat) {
> +			uni_name[uni_len] = 0x0000;
> +			name_len = fat_uni_to_x8(sb, uni_name, name,
> +						 FAT_MAX_SHORT_SIZE);
> +		}
> +	}
> +
> +	return name_len;
> +}
> +
>  /*
>   * Return values: negative -> error, 0 -> not found, positive -> found,
>   * value is the total amount of slots, including the shortname entry.
> @@ -344,15 +449,11 @@ int fat_search_long(struct inode *inode,
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  	struct buffer_head *bh = NULL;
>  	struct msdos_dir_entry *de;
> -	struct nls_table *nls_disk = sbi->nls_disk;
>  	unsigned char nr_slots;
> -	wchar_t bufuname[14];
>  	wchar_t *unicode = NULL;
> -	unsigned char work[MSDOS_NAME];
>  	unsigned char bufname[FAT_MAX_SHORT_SIZE];
> -	unsigned short opt_shortname = sbi->options.shortname;
>  	loff_t cpos = 0;
> -	int chl, i, j, last_u, err, len;
> +	int err, len;
>  
>  	err = -ENOENT;
>  	while (1) {
> @@ -380,47 +481,16 @@ parse_record:
>  				goto end_of_dir;
>  		}
>  
> -		memcpy(work, de->name, sizeof(de->name));
> -		/* see namei.c, msdos_format_name */
> -		if (work[0] == 0x05)
> -			work[0] = 0xE5;
> -		for (i = 0, j = 0, last_u = 0; i < 8;) {
> -			if (!work[i])
> -				break;
> -			chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
> -						&bufuname[j++], opt_shortname,
> -						de->lcase & CASE_LOWER_BASE);
> -			if (chl <= 1) {
> -				if (work[i] != ' ')
> -					last_u = j;
> -			} else {
> -				last_u = j;
> -			}
> -			i += chl;
> -		}
> -		j = last_u;
> -		fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
> -		for (i = 8; i < MSDOS_NAME;) {
> -			if (!work[i])
> -				break;
> -			chl = fat_shortname2uni(nls_disk, &work[i],
> -						MSDOS_NAME - i,
> -						&bufuname[j++], opt_shortname,
> -						de->lcase & CASE_LOWER_EXT);
> -			if (chl <= 1) {
> -				if (work[i] != ' ')
> -					last_u = j;
> -			} else {
> -				last_u = j;
> -			}
> -			i += chl;
> -		}
> -		if (!last_u)
> +		/* Never prepend '.' to hidden files here.
> +		 * That is done only for msdos mounts (and only when
> +		 * 'dotsOK=yes'); if we are executing here, it is in the
> +		 * context of a vfat mount.
> +		 */
> +		len = fat_parse_short(sb, de, bufname, 0);
> +		if (len == 0)
>  			continue;
>  
>  		/* Compare shortname */
> -		bufuname[last_u] = 0x0000;
> -		len = fat_uni_to_x8(sb, bufuname, bufname, sizeof(bufname));
>  		if (fat_name_match(sbi, name, name_len, bufname, len))
>  			goto found;
>  
> @@ -469,20 +539,15 @@ static int __fat_readdir(struct inode *i
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  	struct buffer_head *bh;
>  	struct msdos_dir_entry *de;
> -	struct nls_table *nls_disk = sbi->nls_disk;
>  	unsigned char nr_slots;
> -	wchar_t bufuname[14];
>  	wchar_t *unicode = NULL;
> -	unsigned char c, work[MSDOS_NAME];
> -	unsigned char bufname[FAT_MAX_SHORT_SIZE], *ptname = bufname;
> -	unsigned short opt_shortname = sbi->options.shortname;
> +	unsigned char bufname[FAT_MAX_SHORT_SIZE];
>  	int isvfat = sbi->options.isvfat;
> -	int nocase = sbi->options.nocase;
>  	const char *fill_name = NULL;
>  	unsigned long inum;
>  	unsigned long lpos, dummy, *furrfu = &lpos;
>  	loff_t cpos;
> -	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len = 0;
> +	int short_len = 0, fill_len = 0;
>  	int ret = 0;
>  
>  	lock_super(sb);
> @@ -556,74 +621,10 @@ parse_record:
>  		}
>  	}
>  
> -	if (sbi->options.dotsOK) {
> -		ptname = bufname;
> -		dotoffset = 0;
> -		if (de->attr & ATTR_HIDDEN) {
> -			*ptname++ = '.';
> -			dotoffset = 1;
> -		}
> -	}
> -
> -	memcpy(work, de->name, sizeof(de->name));
> -	/* see namei.c, msdos_format_name */
> -	if (work[0] == 0x05)
> -		work[0] = 0xE5;
> -	for (i = 0, j = 0, last = 0, last_u = 0; i < 8;) {
> -		if (!(c = work[i]))
> -			break;
> -		chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
> -					&bufuname[j++], opt_shortname,
> -					de->lcase & CASE_LOWER_BASE);
> -		if (chl <= 1) {
> -			ptname[i++] = (!nocase && c>='A' && c<='Z') ? c+32 : c;
> -			if (c != ' ') {
> -				last = i;
> -				last_u = j;
> -			}
> -		} else {
> -			last_u = j;
> -			for (chi = 0; chi < chl && i < 8; chi++) {
> -				ptname[i] = work[i];
> -				i++; last = i;
> -			}
> -		}
> -	}
> -	i = last;
> -	j = last_u;
> -	fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
> -	ptname[i++] = '.';
> -	for (i2 = 8; i2 < MSDOS_NAME;) {
> -		if (!(c = work[i2]))
> -			break;
> -		chl = fat_shortname2uni(nls_disk, &work[i2], MSDOS_NAME - i2,
> -					&bufuname[j++], opt_shortname,
> -					de->lcase & CASE_LOWER_EXT);
> -		if (chl <= 1) {
> -			i2++;
> -			ptname[i++] = (!nocase && c>='A' && c<='Z') ? c+32 : c;
> -			if (c != ' ') {
> -				last = i;
> -				last_u = j;
> -			}
> -		} else {
> -			last_u = j;
> -			for (chi = 0; chi < chl && i2 < MSDOS_NAME; chi++) {
> -				ptname[i++] = work[i2++];
> -				last = i;
> -			}
> -		}
> -	}
> -	if (!last)
> +	short_len = fat_parse_short(sb, de, bufname, sbi->options.dotsOK);
> +	if (short_len == 0)
>  		goto record_end;
>  
> -	i = last + dotoffset;
> -	j = last_u;
> -
> -	if (isvfat) {
> -		bufuname[j] = 0x0000;
> -		i = fat_uni_to_x8(sb, bufuname, bufname, sizeof(bufname));
> -	}
>  	if (nr_slots) {
>  		/* hack for fat_ioctl_filldir() */
>  		struct fat_ioctl_filldir_callback *p = dirent;
> @@ -631,12 +632,12 @@ parse_record:
>  		p->longname = fill_name;
>  		p->long_len = fill_len;
>  		p->shortname = bufname;
> -		p->short_len = i;
> +		p->short_len = short_len;
>  		fill_name = NULL;
>  		fill_len = 0;
>  	} else {
>  		fill_name = bufname;
> -		fill_len = i;
> +		fill_len = short_len;
>  	}
>  
>  start_filldir:
>
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
