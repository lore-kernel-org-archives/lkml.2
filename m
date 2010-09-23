Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0IWM5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:57:54 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:62469 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564Ab0IWM5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:57:53 -0400
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level
 PCI drivers
From: Andy Walls <awalls@md.metrocast.net>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 08:58:01 -0400
Message-ID: <1285246681.6715.11.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-23_09:2010-09-23,2010-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009230066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +ssize_t vfio_io_readwrite(
> +		int write,
> +		struct vfio_dev *vdev,
> +		char __user *buf,
> +		size_t count,
> +		loff_t *ppos)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	size_t done = 0;
> +	resource_size_t end;
> +	void __iomem *io;
> +	loff_t pos;
> +	int pci_space;
> +	int unit;
> +
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +	pos = vfio_offset_to_pci_offset(*ppos);
> +
> +	if (!pci_resource_start(pdev, pci_space))
> +		return -EINVAL;
> +	end = pci_resource_len(pdev, pci_space);
> +	if (pos + count > end)
> +		return -EINVAL;
> +	if (vdev->barmap[pci_space] == NULL)
> +		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);

Hi Tom,

pci_iomap() can possibly return NULL here and also in
vfio_mem_readwrite().  Even if there are no security implications
(unintended access to low I/O ports?), I think you still have potential
for an Oops in the code below.

... unless there's a reason why pci_iomap() can't possibly return NULL
in these instances.  Maybe I'm missing something.

Regards,
Andy

> +	io = vdev->barmap[pci_space];
> +
> +	while (count > 0) {
> +		if ((pos % 4) == 0 && count >= 4) {
> +			u32 val;
> +
> +			if (write) {
> +				if (copy_from_user(&val, buf, 4))
> +					return -EFAULT;
> +				iowrite32(val, io + pos);
> +			} else {
> +				val = ioread32(io + pos);
> +				if (copy_to_user(buf, &val, 4))
> +					return -EFAULT;
> +			}
> +			unit = 4;
> +		} else if ((pos % 2) == 0 && count >= 2) {

