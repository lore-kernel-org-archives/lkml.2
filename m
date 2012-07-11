Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2GKPSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:18:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab2GKPSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:18:03 -0400
Date: Wed, 11 Jul 2012 17:15:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Jonathan M. Foote" <jmfoote@cert.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH] Extend core dump note section to contain file names of
	mapped files
Message-ID: <20120711151513.GA9314@redhat.com>
References: <CAK1hOcNWo2mV2nKmVEuzKzEs7pCveFCBFWrYSrMbj4Y7M8zQ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcNWo2mV2nKmVEuzKzEs7pCveFCBFWrYSrMbj4Y7M8zQ6Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11, Denys Vlasenko wrote:
>
> I propose to save this information in core dump, as a new note
> in note segment.

Denys, I am in no position to discuss whether we need this change or not,
format, etc. I'll only try to comment the code.

And please do not use the attachments ;)

> +static void fill_files_note(struct memelfnote *note)
> +{
> +	struct vm_area_struct *vma;
> +	struct file *file;
> +	unsigned count, word_count, size, remaining;
> +	long *data;
> +	long *start_end_ofs;
> +	char *name;
> +
> +	count = 0;
> +	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
> +		file = vma->vm_file;
> +		if (!file)
> +			continue;
> +		count++;
> +		if (count >= MAX_FILE_NOTE_SIZE / 64) /* paranoia check */
> +			goto err;

Why this check? If count is huge, then...

> +	size = count * 64;
> +	word_count = 2 + 3 * count;
> + alloc:
> +	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
> +		goto err;

we should detect this case before the first alloc?

> +	size = (size + PAGE_SIZE - 1) & (-PAGE_SIZE);

Well, I'd suggest PAGE_MASK instead of -PAGE_SIZE. Better yet,

	size = round_up(size, PAGE_SIZE);

> +		if (remaining == 0) {
> + try_new_size:
> +			vfree(data);
> +			size = size * 5 / 4;
> +			goto alloc;
> +		}
> +		filename = d_path(&file->f_path, name, remaining);
> +		if (IS_ERR(filename)) {
> +			if (PTR_ERR(filename) == -ENAMETOOLONG)
> +				goto try_new_size;

This looks like unnecessary complication to me, or I missed something.
d_path(..., buflen) should handle the "buflen == 0" case correctly, so
afacics you can remove the "if (remaining == 0)" block and move this
free-and-goto-alloc code under the -ENAMETOOLONG check.

> +		while ((remaining--, *name++ = *filename++) != '\0')
> +			continue;

Well, perhaps this is just me... but this looks a bit too complex
to me ;) I won't insist, but

		do
			remaining--;
		while ((*name++ = *filename++));

looks more understandable, imho.

Or even

		/* d_path() fills the end of the buffer */
		remaining = name - filename;
		strcpy(name, filename);

Oleg.

